-- Validation 1: Fact table row count
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_item_id) AS unique_order_items
FROM warehouse.fact_order_items;


-- Validation 2: Missing required identifiers
SELECT
    COUNT(*) FILTER (WHERE order_item_id IS NULL)
        AS missing_order_item_ids,
    COUNT(*) FILTER (WHERE order_id IS NULL)
        AS missing_order_ids
FROM warehouse.fact_order_items;


-- Validation 3: Invalid quantities
SELECT
    COUNT(*) FILTER (WHERE quantity IS NULL)
        AS missing_quantities,
    COUNT(*) FILTER (WHERE quantity <= 0)
        AS invalid_quantities
FROM warehouse.fact_order_items;


-- Validation 4: Shipping dates before order dates
SELECT COUNT(*) AS shipping_before_order
FROM warehouse.fact_order_items f
JOIN warehouse.dim_date od
    ON f.order_date_key = od.date_key
JOIN warehouse.dim_date sd
    ON f.shipping_date_key = sd.date_key
WHERE sd.full_date < od.full_date;