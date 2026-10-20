-- 1. Load product dimension
INSERT INTO warehouse.dim_product (
    product_id,
    category_id,
    category_name,
    department_name
)
SELECT DISTINCT
    product_id,
    category_id,
    category_name,
    department_name
FROM staging.stg_dataco_supply_chain
WHERE product_id IS NOT NULL
ON CONFLICT (product_id) DO NOTHING;


-- 2. Load customer dimension
INSERT INTO warehouse.dim_customer (
    customer_id,
    customer_segment,
    customer_city,
    customer_state,
    customer_country
)
SELECT DISTINCT ON (customer_id)
    customer_id,
    customer_segment,
    customer_city,
    customer_state,
    customer_country
FROM staging.stg_dataco_supply_chain
WHERE customer_id IS NOT NULL
ORDER BY customer_id, order_date
ON CONFLICT (customer_id) DO NOTHING;


-- 3. Load shipping dimension
INSERT INTO warehouse.dim_shipping (shipping_mode)
SELECT DISTINCT shipping_mode
FROM staging.stg_dataco_supply_chain
WHERE shipping_mode IS NOT NULL
ON CONFLICT (shipping_mode) DO NOTHING;


-- 4. Load date dimension
INSERT INTO warehouse.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_of_week
)
SELECT
    TO_CHAR(calendar_date, 'YYYYMMDD')::INTEGER AS date_key,
    calendar_date::DATE,
    EXTRACT(YEAR FROM calendar_date)::INTEGER,
    EXTRACT(QUARTER FROM calendar_date)::INTEGER,
    EXTRACT(MONTH FROM calendar_date)::INTEGER,
    TO_CHAR(calendar_date, 'FMMonth'),
    EXTRACT(DAY FROM calendar_date)::INTEGER,
    EXTRACT(DOW FROM calendar_date)::INTEGER
FROM generate_series(
    (
        SELECT MIN(order_date)::DATE
        FROM staging.stg_dataco_supply_chain
    ),
    (
        SELECT MAX(shipping_date)::DATE
        FROM staging.stg_dataco_supply_chain
    ),
    INTERVAL '1 day'
) AS calendar_date
ON CONFLICT (date_key) DO NOTHING;