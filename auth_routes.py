from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash, check_password_hash

from db import query

bp = Blueprint("auth", __name__)


@bp.get("/login")
def login_get():
    return render_template("login.html")


@bp.post("/login")
def login_post():
    username = request.form.get("username", "").strip()
    password = request.form.get("password", "")

    if not username or not password:
        flash("Заполните логин и пароль", "error")
        return redirect(url_for("auth.login_get"))

    user = query(
        "SELECT id, username, email, password_hash, balance, is_admin FROM users WHERE username = %s",
        (username,),
        one=True,
    )
    if not user or not check_password_hash(user["password_hash"], password):
        flash("Неверный логин или пароль", "error")
        return redirect(url_for("auth.login_get"))

    session["user_id"] = user["id"]
    session["username"] = user["username"]
    session["is_admin"] = bool(user["is_admin"])

    flash("Вы успешно вошли", "success")
    return redirect(url_for("index"))


@bp.get("/register")
def register_get():
    return render_template("register.html")


@bp.post("/register")
def register_post():
    username = request.form.get("username", "").strip()
    email = request.form.get("email", "").strip()
    password = request.form.get("password", "")

    if not username or not email or not password:
        flash("Заполните все поля", "error")
        return redirect(url_for("auth.register_get"))

    existing = query(
        "SELECT id FROM users WHERE username = %s OR email = %s",
        (username, email),
        one=True,
    )
    if existing:
        flash("Пользователь с таким логином или email уже существует", "error")
        return redirect(url_for("auth.register_get"))

    password_hash = generate_password_hash(password)

    query(
        "INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s)",
        (username, email, password_hash),
    )

    flash("Регистрация прошла успешно, теперь войдите", "success")
    return redirect(url_for("auth.login_get"))


@bp.post("/logout")
def logout():
    session.clear()
    flash("Вы вышли из аккаунта", "success")
    return redirect(url_for("index"))
