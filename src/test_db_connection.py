
import os
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# Read database settings from environment variables
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "logistics_dw")

if not DB_PASSWORD:
    raise RuntimeError(
        "Set the DB_PASSWORD environment variable first."
    )


DATABASE_URL = URL.create(
    drivername="postgresql+psycopg2",
    username=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=int(DB_PORT),
    database=DB_NAME,
)

engine = create_engine(DATABASE_URL)

try:
    with engine.connect() as connection:
        database = connection.execute(
            text("SELECT current_database()")
        ).scalar_one()

        print("Connection successful!")
        print(f"Connected database: {database}")

except Exception:
    print("Database connection failed.")
    raise

finally:
    engine.dispose()
