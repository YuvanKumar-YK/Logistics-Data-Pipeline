
-- 1. Check total rows
SELECT COUNT(*) AS total_rows
FROM staging.stg_dataco_supply_chain;

-- 2. Check missing important identifiers and dates
SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_ids,
    COUNT(*) FILTER (WHERE order_item_id IS NULL) AS missing_order_item_ids,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS missing_order_dates,
    COUNT(*) FILTER (WHERE shipping_date IS NULL) AS missing_shipping_dates
FROM staging.stg_dataco_supply_chain;

-- 3. Check duplicate order item IDs
SELECT
    COUNT(*) AS duplicate_order_item_ids
FROM (
    SELECT order_item_id
    FROM staging.stg_dataco_supply_chain
    GROUP BY order_item_id
    HAVING COUNT(*) > 1
) AS duplicates;

-- 4. Check whether shipping dates precede order dates
SELECT COUNT(*) AS shipping_before_order
FROM staging.stg_dataco_supply_chain
WHERE shipping_date < order_date;

-- 5. Check delivery status distribution
SELECT
    delivery_status,
    COUNT(*) AS row_count
FROM staging.stg_dataco_supply_chain
GROUP BY delivery_status
ORDER BY row_count DESC;

-- 6. Check negative profit records
SELECT
    COUNT(*) AS negative_profit_rows
FROM staging.stg_dataco_supply_chain
WHERE profit_per_order < 0;

-- 7. Check quantities that are zero or negative
SELECT COUNT(*) AS invalid_quantity_rows
FROM staging.stg_dataco_supply_chain
WHERE quantity <= 0;
