import pandas as pd
import numpy as np
from faker import Faker

fake = Faker()

np.random.seed(42)
Faker.seed(42)

##### CUSTOMERS #####
NUM_CUSTOMERS = 10_000

customers = []

for customer_id in range(1, NUM_CUSTOMERS + 1):
    customers.append({
        "customer_id": customer_id,
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "email": fake.email(),
        "country": np.random.choice(
            ["Canada", "USA", "UK", "Australia"],
            p=[0.45, 0.35, 0.12, 0.08]
        ),
        "signup_date": fake.date_between(
            start_date="-3y",
            end_date="today"
        )
    })

customers_df = pd.DataFrame(customers)

# print(customers_df.head())
# print(customers_df.shape)


##### PRODUCTS #####
NUM_PRODUCTS = 500

categories = [
    "Electronics",
    "Home",
    "Clothing",
    "Books",
    "Sports",
    "Beauty"
]

products = []

for product_id in range(1, NUM_PRODUCTS + 1):

    price = round(np.random.uniform(10, 1000), 2)

    products.append({
        "product_id": product_id,
        "product_name": fake.catch_phrase(),
        "category": np.random.choice(categories),
        "price": price,
        "cost": round(price * np.random.uniform(0.4, 0.8), 2)
    })

products_df = pd.DataFrame(products)


##### ORDERS #####
NUM_ORDERS = 100_000

orders = []

for order_id in range(1, NUM_ORDERS + 1):

    orders.append({
        "order_id": order_id,
        "customer_id": np.random.randint(1, NUM_CUSTOMERS + 1),
        "order_date": fake.date_between(
            start_date="-2y",
            end_date="today"
        ),
        "status": np.random.choice(
            ["completed", "cancelled", "pending"],
            p=[0.85, 0.10, 0.05]
        )
    })

orders_df = pd.DataFrame(orders)


##### ORDER ITEMS #####
order_items = []

order_item_id = 1

for order_id in orders_df["order_id"]:

    number_of_items = np.random.randint(1, 6)

    selected_products = np.random.choice(
        products_df["product_id"],
        size=number_of_items,
        replace=False
    )

    for product_id in selected_products:

        product_price = products_df.loc[
            products_df["product_id"] == product_id,
            "price"
        ].iloc[0]

        quantity = np.random.randint(1, 4)

        order_items.append({
            "order_item_id": order_item_id,
            "order_id": order_id,
            "product_id": product_id,
            "quantity": quantity,
            "unit_price": product_price
        })

        order_item_id += 1

order_items_df = pd.DataFrame(order_items)


##### ORDER ITEMS #####
payments = []

for payment_id, order_id in enumerate(orders_df["order_id"], start=1):

    order_items_for_order = order_items_df[
        order_items_df["order_id"] == order_id
    ]

    amount = (
        order_items_for_order["quantity"] *
        order_items_for_order["unit_price"]
    ).sum()

    payments.append({
        "payment_id": payment_id,
        "order_id": order_id,
        "payment_date": fake.date_between(
            start_date="-2y",
            end_date="today"
        ),
        "amount": round(amount, 2),
        "payment_method": np.random.choice(
            ["credit_card", "paypal", "bank_transfer"],
            p=[0.65, 0.25, 0.10]
        ),
        "payment_status": np.random.choice(
            ["completed", "failed", "refunded"],
            p=[0.90, 0.07, 0.03]
        )
    })

payments_df = pd.DataFrame(payments)


##### WEB EVENTS #####
NUM_EVENTS = 200_000

events = []

event_types = [
    "page_view",
    "product_view",
    "add_to_cart",
    "purchase"
]

for event_id in range(1, NUM_EVENTS + 1):

    events.append({
        "event_id": event_id,
        "customer_id": np.random.randint(
            1,
            NUM_CUSTOMERS + 1
        ),
        "event_timestamp": fake.date_time_between(
            start_date="-2y",
            end_date="now"
        ),
        "event_type": np.random.choice(event_types),
        "product_id": np.random.randint(
            1,
            NUM_PRODUCTS + 1
        )
    })

events_df = pd.DataFrame(events)


######### INTRODUCE BAD DATA
# missing countries
missing_indices = np.random.choice(
    customers_df.index,
    size=100,
    replace=False
)

customers_df.loc[
    missing_indices,
    "country"
] = None

# inconsistent capitalization
customers_df.loc[
    customers_df.sample(100).index,
    "country"
] = "canada"

# invalid records
bad_indices = np.random.choice(
    order_items_df.index,
    size=10,
    replace=False
)

order_items_df.loc[
    bad_indices,
    "quantity"
] = -1

############ SAVE
from pathlib import Path

Path("data").mkdir(exist_ok=True)
customers_df.to_csv(
    "data/customers.csv",
    index=False
)

products_df.to_csv(
    "data/products.csv",
    index=False
)

orders_df.to_csv(
    "data/orders.csv",
    index=False
)

order_items_df.to_csv(
    "data/order_items.csv",
    index=False
)

payments_df.to_csv(
    "data/payments.csv",
    index=False
)

events_df.to_csv(
    "data/events.csv",
    index=False
)