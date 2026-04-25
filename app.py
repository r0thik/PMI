from flask import Flask, render_template, session, redirect, url_for, flash, request

import random
import string
from datetime import datetime, date

from db import query, get_conn
from config import Config
from auth_routes import bp as auth_bp
from admin_routes import bp as admin_bp

app = Flask(__name__)
app.config.from_object(Config)
app.register_blueprint(auth_bp)
app.register_blueprint(admin_bp)

ALPHABET = string.ascii_uppercase + string.digits

MONTHS_RU = [
    "января",
    "февраля",
    "марта",
    "апреля",
    "мая",
    "июня",
    "июля",
    "августа",
    "сентября",
    "октября",
    "ноября",
    "декабря",
]


def generate_key() -> str:
    groups = ["".join(random.choices(ALPHABET, k=5)) for _ in range(5)]
    return "-".join(groups)


def format_datetime_ru(value):
    """Формат: 6 декабря 2025 в 19:33 или 6 декабря 2025 для дат без времени."""
    if value is None:
        return ""

    if isinstance(value, str):
        try:
            value = datetime.fromisoformat(value)
        except ValueError:
            return value

    if isinstance(value, date) and not isinstance(value, datetime):
        d = value.day
        m = MONTHS_RU[value.month - 1]
        y = value.year
        return f"{d} {m} {y}"

    if isinstance(value, datetime):
        d = value.day
        m = MONTHS_RU[value.month - 1]
        y = value.year
        t = value.strftime("%H:%M")
        return f"{d} {m} {y} в {t}"

    return value


app.add_template_filter(format_datetime_ru, name="datetime_ru")


@app.context_processor
def inject_current_user():
    user = None
    user_id = session.get("user_id")
    if user_id:
        user = query(
            "SELECT id, username, balance, is_admin FROM users WHERE id = %s",
            (user_id,),
            one=True,
        )
    return {"current_user": user}


@app.get("/")
def index():
    news = query(
        "SELECT title, summary, date FROM news ORDER BY date DESC"
    ) or []
    partners = query(
        "SELECT name FROM partners ORDER BY name"
    ) or []
    holidays = query(
        "SELECT name, date, note FROM holidays ORDER BY date"
    ) or []
    price_updates = query(
        "SELECT date, text FROM price_updates ORDER BY date DESC"
    ) or []

    return render_template(
        "index.html",
        news=news,
        partners=partners,
        holidays=holidays,
        price_updates=price_updates,
    )


@app.get("/catalog")
def catalog():
    """Каталог товаров с фильтрацией по жанру через query-параметр ?genre=..."""
    genre = request.args.get("genre", "").strip()

    if genre:
        items = query(
            "SELECT id, title, description, price, image, genre FROM products "
            "WHERE genre = %s ORDER BY id",
            (genre,),
        ) or []
    else:
        items = query(
            "SELECT id, title, description, price, image, genre FROM products ORDER BY id"
        ) or []

    genres = query(
        "SELECT DISTINCT genre FROM products WHERE genre IS NOT NULL AND genre <> '' ORDER BY genre"
    ) or []

    return render_template(
        "catalog.html",
        items=items,
        genres=genres,
        current_genre=genre or "",
    )


@app.post("/buy/<int:product_id>")
def buy(product_id: int):
    user_id = session.get("user_id")
    if not user_id:
        flash("Для покупки нужно войти в аккаунт", "error")
        return redirect(url_for("auth.login_get"))

    conn = get_conn()
    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT price, title, stock FROM products WHERE id = %s FOR UPDATE",
                    (product_id,),
                )
                row = cur.fetchone()
                if not row:
                    flash("Товар не найден", "error")
                    return redirect(url_for("catalog"))

                price, title, stock = row[0], row[1], row[2]

                if stock is not None and stock <= 0:
                    flash("Товар закончился", "error")
                    return redirect(url_for("catalog"))

                cur.execute(
                    "SELECT balance FROM users WHERE id = %s FOR UPDATE",
                    (user_id,),
                )
                user_row = cur.fetchone()
                if not user_row:
                    flash("Пользователь не найден", "error")
                    return redirect(url_for("catalog"))

                balance = user_row[0]
                if balance < price:
                    flash("Недостаточно средств для покупки", "error")
                    return redirect(url_for("catalog"))

                cur.execute(
                    "UPDATE users SET balance = balance - %s WHERE id = %s",
                    (price, user_id),
                )

                cur.execute(
                    "UPDATE products SET stock = stock - 1 WHERE id = %s",
                    (product_id,),
                )

                cur.execute(
                    "INSERT INTO orders (user_id, total) VALUES (%s, %s) RETURNING id",
                    (user_id, price),
                )
                order_id = cur.fetchone()[0]

                cur.execute(
                    "INSERT INTO order_items (order_id, product_id, unit_price, quantity) "
                    "VALUES (%s, %s, %s, 1)",
                    (order_id, product_id, price),
                )

                key_value = None
                for _ in range(5):
                    candidate = generate_key()
                    try:
                        cur.execute(
                            "INSERT INTO license_keys (order_id, user_id, product_id, key_value) "
                            "VALUES (%s, %s, %s, %s)",
                            (order_id, user_id, product_id, candidate),
                        )
                        key_value = candidate
                        break
                    except Exception:
                        conn.rollback()
                        conn.begin()

                if not key_value:
                    flash("Не удалось сгенерировать ключ, попробуйте позже", "error")
                    return redirect(url_for("catalog"))

        flash(f"Покупка '{title}' успешна! Ваш ключ: {key_value}", "success")
    finally:
        conn.close()

    return redirect(url_for("catalog"))


@app.get("/purchases")
def purchases():
    if not session.get("user_id"):
        flash("Для просмотра истории покупок нужно войти в аккаунт", "error")
        return redirect(url_for("auth.login_get"))

    user_id = session["user_id"]
    purchases = query(
        """
        SELECT p.title,
               lk.key_value,
               o.created_at
        FROM license_keys lk
        JOIN orders o ON lk.order_id = o.id
        JOIN products p ON lk.product_id = p.id
        WHERE lk.user_id = %s
        ORDER BY o.created_at DESC
        """,
        (user_id,),
    ) or []

    return render_template("purchases.html", purchases=purchases)


@app.get("/info")
def info():
    return render_template("info.html")




if __name__ == "__main__":
    import os
    host = os.environ.get("FLASK_HOST", "0.0.0.0")
    port = int(os.environ.get("FLASK_PORT", 5000))
    debug = os.environ.get("FLASK_DEBUG", "false").lower() == "true"
    
    app.run(host=host, port=port, debug=debug)
