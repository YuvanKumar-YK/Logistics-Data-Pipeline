--warehouse.dim_product
CREATE TABLE IF NOT EXISTS warehouse.dim_product (
    product_id BIGINT PRIMARY KEY,
    category_id BIGINT,
    category_name TEXT,
    department_name TEXT
);

--warehouse.dim_customer
CREATE TABLE IF NOT EXISTS warehouse.dim_customer (
    customer_id BIGINT PRIMARY KEY,
    customer_segment TEXT,
    customer_city TEXT,
    customer_state TEXT,
    customer_country TEXT
);

--warehouse.dim_date
CREATE TABLE IF NOT EXISTS warehouse.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name TEXT NOT NULL,
    day INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL
);

--shipping dimension
CREATE TABLE IF NOT EXISTS warehouse.dim_shipping (
    shipping_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shipping_mode TEXT UNIQUE NOT NULL
);

--fact table
CREATE TABLE IF NOT EXISTS warehouse.fact_order_items (
    order_item_id BIGINT PRIMARY KEY,
    order_id BIGINT NOT NULL,

    customer_id BIGINT REFERENCES warehouse.dim_customer(customer_id),
    product_id BIGINT REFERENCES warehouse.dim_product(product_id),

    order_date_key INTEGER REFERENCES warehouse.dim_date(date_key),
    shipping_date_key INTEGER REFERENCES warehouse.dim_date(date_key),
    shipping_key INTEGER REFERENCES warehouse.dim_shipping(shipping_key),

    order_status TEXT,
    delivery_status TEXT,
    late_delivery_risk INTEGER,

    quantity INTEGER,
    product_price NUMERIC(12, 2),
    order_item_total NUMERIC(12, 2),
    sales NUMERIC(12, 2),
    profit_per_order NUMERIC(12, 2),
    benefit_per_order NUMERIC(12, 2),
    item_discount NUMERIC(12, 2),

    actual_shipping_days INTEGER,
    scheduled_shipping_days INTEGER,

    market TEXT,
    order_region TEXT,
    order_country TEXT,
    order_state TEXT,
    order_city TEXT
);