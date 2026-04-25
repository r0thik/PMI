import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret-key-change-in-production")
    
    POSTGRES_HOST = os.environ.get("POSTGRES_HOST", "postgres")
    POSTGRES_PORT = os.environ.get("POSTGRES_PORT", 5432)
    POSTGRES_DB = os.environ.get("POSTGRES_DB", "steam_db")
    POSTGRES_USER = os.environ.get("POSTGRES_USER", "postgres")
    POSTGRES_PASSWORD = os.environ.get("POSTGRES_PASSWORD", "1234")
    
    DATABASE_URL = os.environ.get(
        "DATABASE_URL",
        f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"
    )
    
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
    SQLALCHEMY_TRACK_MODIFICATIONS = False