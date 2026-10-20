
from pathlib import Path
import logging
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_FILE = (
    PROJECT_ROOT
    / "data"
    / "raw"
    / "DataCoSupplyChainDataset.csv"
)

LOG_DIR = PROJECT_ROOT / "logs"
LOG_DIR.mkdir(exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
    handlers=[
        logging.FileHandler(LOG_DIR / "ingestion.log", encoding="utf-8"),
        logging.StreamHandler()
    ],
)

logger = logging.getLogger(__name__)


def load_data():
    """Load and validate the source dataset."""

    logger.info("Starting DataCo ingestion")

    if not DATA_FILE.exists():
        logger.error("Dataset not found: %s", DATA_FILE)
        raise FileNotFoundError(f"Dataset not found: {DATA_FILE}")

    try:
        df = pd.read_csv(DATA_FILE, encoding="latin1")

        if df.empty:
            raise ValueError("Dataset is empty")

        if df.columns.duplicated().any():
            raise ValueError("Duplicate column names found")

        empty_rows = int(df.isna().all(axis=1).sum())
        missing_values = int(df.isna().sum().sum())

        logger.info("Dataset loaded successfully")
        logger.info("Rows: %s", f"{len(df):,}")
        logger.info("Columns: %s", len(df.columns))
        logger.info("Completely empty rows: %s", empty_rows)
        logger.info("Total missing values: %s", f"{missing_values:,}")

        return df

    except Exception:
        logger.exception("Ingestion failed")
        raise


if __name__ == "__main__":
    load_data()
