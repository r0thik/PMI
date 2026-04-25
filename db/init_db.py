import psycopg2
from pathlib import Path

DB_SETTINGS = {
    "host": "localhost",
    "port": 5432,
    "dbname": "postgres",  # при необходимости поменяй на свою БД
    "user": "postgres",
    "password": "1234",
}


def run_sql_file(conn, path: Path) -> None:
    with path.open("r", encoding="utf-8") as f:
        sql = f.read()
    with conn.cursor() as cur:
        cur.execute(sql)
    conn.commit()


def seed_data(conn) -> None:
    """Минимальное наполнение тестовыми данными.
    При желании можно расширить под твой каталог/новости.
    """
    with conn.cursor() as cur:
        # Пример одного продукта
        cur.execute(
            """
            INSERT INTO products (title, description, price, image, stock)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT DO NOTHING;
            """,
            (
                "RV There Yet?",
                "Кооперативная аркада про путешествие на автодоме.",
                299.00,
                "img/rv-there-yet.jpg",
                10,
            ),
        )

        # Пара партнёров
        cur.execute(
            """
            INSERT INTO partners (name) VALUES
            (%s), (%s), (%s)
            ON CONFLICT DO NOTHING;
            """,
            ("Партнёр 1", "Партнёр 2", "Партнёр 3"),
        )

        # Пример новостей/праздников/обновлений
        cur.execute(
            """
            INSERT INTO news (title, summary, date)
            VALUES (%s, %s, %s)
            ON CONFLICT DO NOTHING;
            """,
            (
                "RV There Yet? анонсирован",
                "Кооперативная аркада добавлена в каталог.",
                "2025-10-01",
            ),
        )
        cur.execute(
            """
            INSERT INTO holidays (name, date, note)
            VALUES (%s, %s, %s)
            ON CONFLICT DO NOTHING;
            """,
            ("День разработчика", "2025-09-13", "Спецподборка инди-игр"),
        )
        cur.execute(
            """
            INSERT INTO price_updates (date, text)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING;
            """,
            ("2025-10-01", "Обновлены цены на раздел X"),
        )

    conn.commit()


def main() -> None:
    sql_path = Path("models.sql")
    conn = psycopg2.connect(**DB_SETTINGS)
    try:
        run_sql_file(conn, sql_path)
        seed_data(conn)
    finally:
        conn.close()


if __name__ == "__main__":
    main()
