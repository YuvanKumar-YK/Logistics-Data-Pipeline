
import os
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_FILE = (
    PROJECT_ROOT / "data" / "raw" / "DataCoSupplyChainDataset.csv"
)

DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_NAME = os.getenv("DB_NAME", "logistics_dw")

if not DB_PASSWORD:
    raise RuntimeError("Set DB_PASSWORD in your PowerShell terminal.")

if not DATA_FILE.exists():
    raise FileNotFoundError(f"Dataset not found: {DATA_FILE}")

database_url = URL.create(
    "postgresql+psycopg2",
    username=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT,
    database=DB_NAME,
)

engine = create_engine(database_url)

try:
    print("Reading DataCo CSV...")
    df = pd.read_csv(DATA_FILE, encoding="latin1")

    print(f"Loaded {len(df):,} rows. Writing to PostgreSQL...")

    # Create the raw schema if it doesn't exist.
    with engine.begin() as connection:
        connection.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))

    # Load in chunks to limit memory usage during database insertion.
    df.to_sql(
    name="dataco_supply_chain",
    con=engine,
    schema="raw",
    if_exists="replace",
    index=False,
    chunksize=2000,
    method=None,
)

    print("CSV loaded into raw.dataco_supply_chain")

    with engine.connect() as connection:
        count = connection.execute(
            text("SELECT COUNT(*) FROM raw.dataco_supply_chain")
        ).scalar_one()

    print(f"Rows verified in PostgreSQL: {count:,}")

finally:
    engine.dispose()
