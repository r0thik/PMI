from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash
from datetime import date

from db import query, get_conn

bp = Blueprint("admin", __name__, url_prefix="/admin")


def require_admin():
    if not session.get("user_id") or not session.get("is_admin"):
        flash("Доступ в админ-панель только для администраторов", "error")
        return False
    return True


@bp.get("/")
def admin_index():
    if not require_admin():
        return redirect(url_for("index"))
    return redirect(url_for("admin.products"))


# ------------ ТОВАРЫ ------------

@bp.get("/products")
def products():
    if not require_admin():
        return redirect(url_for("index"))

    products = query(
        "SELECT id, title, description, price, image, stock, genre FROM products ORDER BY id"
    ) or []
    return render_template("admin_products.html", products=products)


@bp.post("/products/add")
def product_add():
    if not require_admin():
        return redirect(url_for("index"))

    title = request.form.get("title", "").strip()
    description = request.form.get("description", "").strip()
    image = request.form.get("image", "").strip()
    price = request.form.get("price", "").strip()
    stock = request.form.get("stock", "0").strip()
    genre = request.form.get("genre", "").strip()

    if not title or not price:
        flash("Заполните название и цену", "error")
        return redirect(url_for("admin.products"))

    try:
        price_val = float(price)
        stock_val = int(stock or 0)
    except ValueError:
        flash("Некорректный формат цены или количества", "error")
        return redirect(url_for("admin.products"))

    query(
        "INSERT INTO products (title, description, price, image, stock, genre) VALUES (%s, %s, %s, %s, %s, %s)",
        (title, description or None, price_val, image or None, stock_val, genre or None),
    )

    news_title = f"Добавлена новая игра: {title}"
    news_summary = description or None
    today = date.today()
    query(
        "INSERT INTO news (title, summary, date) VALUES (%s, %s, %s)",
        (news_title, news_summary, today),
    )

    flash("Товар добавлен и новость создана", "success")
    return redirect(url_for("admin.products"))


@bp.post("/products/<int:product_id>/update")
def product_update(product_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    title = request.form.get("title", "").strip()
    description = request.form.get("description", "").strip()
    image = request.form.get("image", "").strip()
    price = request.form.get("price", "").strip()
    stock = request.form.get("stock", "0").strip()
    genre = request.form.get("genre", "").strip()

    if not title or not price:
        flash("Заполните название и цену", "error")
        return redirect(url_for("admin.products"))

    try:
        price_val = float(price)
        stock_val = int(stock or 0)
    except ValueError:
        flash("Некорректный формат цены или количества", "error")
        return redirect(url_for("admin.products"))

    old_data = query(
        "SELECT title, price FROM products WHERE id = %s",
        (product_id,),
        one=True,
    )

    query(
        "UPDATE products SET title = %s, description = %s, price = %s, image = %s, stock = %s, genre = %s WHERE id = %s",
        (title, description or None, price_val, image or None, stock_val, genre or None, product_id),
    )

    if old_data is not None:
        old_price = float(old_data["price"])
        if abs(old_price - price_val) > 1e-9:
            game_title = old_data["title"] or title
            text = (
                f"Изменена цена игры '{game_title}': "
                f"была {old_price:.2f} ₽, стала {price_val:.2f} ₽"
            )
            today = date.today()
            query(
                "INSERT INTO price_updates (date, text) VALUES (%s, %s)",
                (today, text),
            )

    flash("Товар обновлён", "success")
    return redirect(url_for("admin.products"))


@bp.post("/products/<int:product_id>/delete")
def product_delete(product_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    query("DELETE FROM products WHERE id = %s", (product_id,))
    flash("Товар удалён", "success")
    return redirect(url_for("admin.products"))


# ------------ ПОЛЬЗОВАТЕЛИ ------------

@bp.get("/users")
def users():
    if not require_admin():
        return redirect(url_for("index"))

    users = query(
        "SELECT id, username, email, balance, is_admin FROM users ORDER BY id"
    ) or []
    return render_template("admin_users.html", users=users)


@bp.post("/users/add")
def user_add():
    if not require_admin():
        return redirect(url_for("index"))

    username = request.form.get("username", "").strip()
    email = request.form.get("email", "").strip()
    password = request.form.get("password", "")
    balance = request.form.get("balance", "0").strip()
    is_admin = request.form.get("is_admin") == "1"

    if not username or not email or not password:
        flash("Заполните логин, email и пароль", "error")
        return redirect(url_for("admin.users"))

    existing = query(
        "SELECT id FROM users WHERE username = %s OR email = %s",
        (username, email),
        one=True,
    )
    if existing:
        flash("Пользователь с таким логином или email уже существует", "error")
        return redirect(url_for("admin.users"))

    try:
        balance_val = float(balance)
    except ValueError:
        flash("Некорректный формат баланса", "error")
        return redirect(url_for("admin.users"))

    password_hash = generate_password_hash(password)

    query(
        "INSERT INTO users (username, email, password_hash, balance, is_admin) VALUES (%s, %s, %s, %s, %s)",
        (username, email, password_hash, balance_val, is_admin),
    )

    flash("Пользователь создан", "success")
    return redirect(url_for("admin.users"))


@bp.post("/users/<int:user_id>/update")
def user_update(user_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    username = request.form.get("username", "").strip()
    email = request.form.get("email", "").strip()
    password = request.form.get("password", "")

    if not username or not email:
        flash("Логин и email не могут быть пустыми", "error")
        return redirect(url_for("admin.users"))

    existing = query(
        "SELECT id FROM users WHERE (username = %s OR email = %s) AND id <> %s",
        (username, email, user_id),
        one=True,
    )
    if existing:
        flash("Логин или email уже заняты другим пользователем", "error")
        return redirect(url_for("admin.users"))

    if password:
        password_hash = generate_password_hash(password)
        query(
            "UPDATE users SET username = %s, email = %s, password_hash = %s WHERE id = %s",
            (username, email, password_hash, user_id),
        )
    else:
        query(
            "UPDATE users SET username = %s, email = %s WHERE id = %s",
            (username, email, user_id),
        )

    flash("Данные пользователя обновлены", "success")
    return redirect(url_for("admin.users"))


@bp.post("/users/<int:user_id>/set_admin")
def user_set_admin(user_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    is_admin = request.form.get("is_admin") == "1"
    query(
        "UPDATE users SET is_admin = %s WHERE id = %s",
        (is_admin, user_id),
    )
    flash("Права администратора обновлены", "success")
    return redirect(url_for("admin.users"))


@bp.post("/users/<int:user_id>/set_balance")
def user_set_balance(user_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    balance = request.form.get("balance", "0").strip()
    try:
        balance_val = float(balance)
    except ValueError:
        flash("Некорректный формат баланса", "error")
        return redirect(url_for("admin.users"))

    query(
        "UPDATE users SET balance = %s WHERE id = %s",
        (balance_val, user_id),
    )
    flash("Баланс пользователя обновлён", "success")
    return redirect(url_for("admin.users"))


@bp.post("/users/<int:user_id>/delete")
def user_delete(user_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    query("DELETE FROM users WHERE id = %s", (user_id,))
    flash("Пользователь удалён", "success")
    return redirect(url_for("admin.users"))


@bp.get("/users/<int:user_id>/orders")
def user_orders(user_id: int):
    """Просмотр заказов и ключей конкретного пользователя в админ-панели."""
    if not require_admin():
        return redirect(url_for("index"))

    user = query(
        "SELECT id, username, email FROM users WHERE id = %s",
        (user_id,),
        one=True,
    )
    if not user:
        flash("Пользователь не найден", "error")
        return redirect(url_for("admin.users"))

    orders = query(
        """
        SELECT o.id AS order_id,
               o.created_at,
               o.total,
               p.title AS product_title,
               lk.key_value
        FROM orders o
        JOIN license_keys lk ON lk.order_id = o.id
        JOIN products p ON lk.product_id = p.id
        WHERE o.user_id = %s
        ORDER BY o.created_at DESC, o.id DESC
        """,
        (user_id,),
    ) or []

    return render_template("admin_user_orders.html", user=user, orders=orders)


# ------------ КОНТЕНТ ------------

@bp.get("/content")
def content_index():
    if not require_admin():
        return redirect(url_for("index"))

    news = query(
        "SELECT id, title, summary, date FROM news ORDER BY date DESC"
    ) or []
    partners = query(
        "SELECT id, name FROM partners ORDER BY name"
    ) or []
    holidays = query(
        "SELECT id, name, date, note FROM holidays ORDER BY date",
    ) or []
    price_updates = query(
        "SELECT id, date, text FROM price_updates ORDER BY date DESC",
    ) or []

    return render_template(
        "admin_content.html",
        news=news,
        partners=partners,
        holidays=holidays,
        price_updates=price_updates,
    )


@bp.post("/content/news/add")
def content_news_add():
    if not require_admin():
        return redirect(url_for("index"))

    title = request.form.get("title", "").strip()
    summary = request.form.get("summary", "").strip()
    date = request.form.get("date", "").strip()

    if not title or not date:
        flash("Заполните заголовок и дату новости", "error")
        return redirect(url_for("admin.content_index"))

    query(
        "INSERT INTO news (title, summary, date) VALUES (%s, %s, %s)",
        (title, summary or None, date),
    )
    flash("Новость добавлена", "success")
    return redirect(url_for("admin.content_index"))


@bp.post("/content/news/<int:item_id>/delete")
def content_news_delete(item_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    query("DELETE FROM news WHERE id = %s", (item_id,))
    flash("Новость удалена", "success")
    return redirect(url_for("admin.content_index"))


@bp.post("/content/partners/add")
def content_partners_add():
    if not require_admin():
        return redirect(url_for("index"))

    name = request.form.get("name", "").strip()
    if not name:
        flash("Введите название организации", "error")
        return redirect(url_for("admin.content_index"))

    query("INSERT INTO partners (name) VALUES (%s)", (name,))
    flash("Организация добавлена", "success")
    return redirect(url_for("admin.content_index"))


@bp.post("/content/partners/<int:item_id>/delete")
def content_partners_delete(item_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    query("DELETE FROM partners WHERE id = %s", (item_id,))
    flash("Организация удалена", "success")
    return redirect(url_for("admin.content_index"))


@bp.post("/content/holidays/add")
def content_holidays_add():
    if not require_admin():
        return redirect(url_for("index"))

    name = request.form.get("name", "").strip()
    date = request.form.get("date", "").strip()
    note = request.form.get("note", "").strip()

    if not name or not date:
        flash("Заполните название и дату праздника", "error")
        return redirect(url_for("admin.content_index"))

    query(
        "INSERT INTO holidays (name, date, note) VALUES (%s, %s, %s)",
        (name, date, note or None),
    )
    flash("Праздник добавлен", "success")
    return redirect(url_for("admin.content_index"))


@bp.post("/content/holidays/<int:item_id>/delete")
def content_holidays_delete(item_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    query("DELETE FROM holidays WHERE id = %s", (item_id,))
    flash("Праздник удалён", "success")
    return redirect(url_for("admin.content_index"))


@bp.post("/content/price_updates/add")
def content_price_updates_add():
    if not require_admin():
        return redirect(url_for("index"))

    date = request.form.get("date", "").strip()
    text = request.form.get("text", "").strip()

    if not date or not text:
        flash("Заполните дату и текст изменения", "error")
        return redirect(url_for("admin.content_index"))

    query(
        "INSERT INTO price_updates (date, text) VALUES (%s, %s)",
        (date, text),
    )
    flash("Запись об изменении прайса добавлена", "success")
    return redirect(url_for("admin.content_index"))


@bp.post("/content/price_updates/<int:item_id>/delete")
def content_price_updates_delete(item_id: int):
    if not require_admin():
        return redirect(url_for("index"))

    query("DELETE FROM price_updates WHERE id = %s", (item_id,))
    flash("Запись об изменении прайса удалена", "success")
    return redirect(url_for("admin.content_index"))
