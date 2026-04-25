import os
import psycopg2
from psycopg2.extras import RealDictCursor

DB_SETTINGS = {
    "host": os.environ.get("POSTGRES_HOST", "postgres"),
    "port": int(os.environ.get("POSTGRES_PORT", 5432)),
    "dbname": os.environ.get("POSTGRES_DB", "steam_db"),
    "user": os.environ.get("POSTGRES_USER", "postgres"),
    "password": os.environ.get("POSTGRES_PASSWORD", "1234"),
}

def get_conn():
    return psycopg2.connect(**DB_SETTINGS)

def query(sql: str, params=None, one: bool = False):
    conn = get_conn()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, params or ())
            if cur.description:
                rows = cur.fetchall()
            else:
                rows = None
        conn.commit()
        if one:
            return rows[0] if rows else None
        return rows
    finally:
        conn.close()