import pandas as pd
from sqlalchemy import create_engine

import os
from dotenv import load_dotenv
load_dotenv()
# Access your variables
db_user = os.getenv("POSTGRES_USER")
db_password = os.getenv("POSTGRES_PASSWORD")
host = os.getenv("POSTGRES_HOST")
port = os.getenv("POSTGRES_PORT")
db_name = os.getenv("POSTGRES_DB")
engine = create_engine(
    "postgresql+psycopg2://"+db_user+":"+db_password+"@"+host+":"+port+"/"+db_name
)

#test connection
with engine.connect() as connection:
    print("Successfully connected to PostgreSQL!")


#add customers
##1- from csv to df
customers_df = pd.read_csv(
    "data/customers.csv"
)
##2- from python df to postgre
customers_df.to_sql(
    "customers",
    engine,
    schema="raw",
    if_exists="replace",
    index=False
)

#add the other dataframes at once just like above:
files = {
    "customers": "data/customers.csv",
    "products": "data/products.csv",
    "orders": "data/orders.csv",
    "order_items": "data/order_items.csv",
    "payments": "data/payments.csv",
    "events": "data/events.csv"
}

for table_name, file_path in files.items():
    print(f"Loading {file_path}...")

    df = pd.read_csv(file_path)

    df.to_sql(
        table_name,
        engine,
        schema="raw",
        if_exists="replace",
        index=False
    )

    print(f"Loaded {len(df):,} rows into raw.{table_name}")
