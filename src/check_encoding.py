
import pandas as pd

file_path = "data/raw/DataCoSupplyChainDataset.csv"

for encoding in ["latin1", "utf-8", "cp1252"]:
    try:
        df = pd.read_csv(
            file_path,
            encoding=encoding,
            usecols=["Order State"]
        )

        values = df["Order State"].dropna()
        matches = values[
            values.str.contains("Rajast", case=False, na=False)
        ]

        print(f"\nEncoding: {encoding}")
        print("Matching values:", matches.unique()[:5])

    except Exception as e:
        print(f"\nEncoding: {encoding} failed: {e}")
