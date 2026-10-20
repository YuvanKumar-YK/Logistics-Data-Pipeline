-- KPI 1: Delivery status distribution
SELECT
    delivery_status,
    COUNT(*) AS order_item_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM warehouse.fact_order_items
GROUP BY delivery_status
ORDER BY order_item_count DESC;

-- KPI 2: Average actual shipping days by shipping mode
SELECT
    sh.shipping_mode,
    COUNT(*) AS order_item_count,
    ROUND(AVG(f.actual_shipping_days), 2)
        AS avg_actual_shipping_days,
    ROUND(AVG(f.scheduled_shipping_days), 2)
        AS avg_scheduled_shipping_days
FROM warehouse.fact_order_items f
JOIN warehouse.dim_shipping sh
    ON f.shipping_key = sh.shipping_key
WHERE f.actual_shipping_days IS NOT NULL
GROUP BY sh.shipping_mode
ORDER BY avg_actual_shipping_days;

-- KPI 3: Sales and profit analysis by market

SELECT
    market,
    COUNT(*) AS order_item_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit_per_order), 2) AS total_profit,
    ROUND(AVG(profit_per_order), 2) AS avg_profit_per_item
FROM warehouse.fact_order_items
GROUP BY market
ORDER BY total_profit DESC;

-- KPI 4: Late-delivery rate by shipping mode
SELECT
    sh.shipping_mode,
    COUNT(*) AS total_order_items,
    COUNT(*) FILTER (
        WHERE f.delivery_status = 'Late delivery'
    ) AS late_order_items,
    ROUND(
        COUNT(*) FILTER (
            WHERE f.delivery_status = 'Late delivery'
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_percentage
FROM warehouse.fact_order_items f
JOIN warehouse.dim_shipping sh
    ON f.shipping_key = sh.shipping_key
GROUP BY sh.shipping_mode
ORDER BY late_delivery_percentage DESC;

-- KPI 5: Monthly order and sales trends
SELECT
    DATE_TRUNC('month', d.full_date)::DATE AS order_month,
    COUNT(*) AS order_item_count,
    COUNT(DISTINCT f.order_id) AS unique_orders,
    ROUND(SUM(f.sales), 2) AS total_sales
FROM warehouse.fact_order_items f
JOIN warehouse.dim_date d
    ON f.order_date_key = d.date_key
GROUP BY DATE_TRUNC('month', d.full_date)
ORDER BY order_month;

-- KPI 6: Monthly late-delivery rate
SELECT
    DATE_TRUNC('month', d.full_date)::DATE AS order_month,
    COUNT(*) AS total_order_items,
    COUNT(*) FILTER (
        WHERE f.delivery_status = 'Late delivery'
    ) AS late_order_items,
    ROUND(
        COUNT(*) FILTER (
            WHERE f.delivery_status = 'Late delivery'
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_percentage
FROM warehouse.fact_order_items f
JOIN warehouse.dim_date d
    ON f.order_date_key = d.date_key
GROUP BY DATE_TRUNC('month', d.full_date)
ORDER BY order_month;

-- KPI 7: Sales and profit field by product category
SELECT
    p.category_name,
    COUNT(*) AS order_item_count,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(AVG(f.profit_per_order), 2) AS avg_profit_field
FROM warehouse.fact_order_items f
JOIN warehouse.dim_product p
    ON f.product_id = p.product_id
GROUP BY p.category_name
ORDER BY total_sales DESC;

-- KPI 8: Order status distribution
SELECT
    order_status,
    COUNT(*) AS order_item_count,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM warehouse.fact_order_items
GROUP BY order_status
ORDER BY order_item_count DESC;

-- KPI 9: Shipping delay by shipping mode
SELECT
    sh.shipping_mode,
    COUNT(*) AS order_item_count,
    ROUND(
        AVG(f.actual_shipping_days - f.scheduled_shipping_days),
        2
    ) AS avg_delay_days,
    COUNT(*) FILTER (
        WHERE f.actual_shipping_days > f.scheduled_shipping_days
    ) AS items_over_schedule,
    ROUND(
        COUNT(*) FILTER (
            WHERE f.actual_shipping_days > f.scheduled_shipping_days
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS over_schedule_percentage
FROM warehouse.fact_order_items f
JOIN warehouse.dim_shipping sh
    ON f.shipping_key = sh.shipping_key
WHERE f.actual_shipping_days IS NOT NULL
  AND f.scheduled_shipping_days IS NOT NULL
GROUP BY sh.shipping_mode
ORDER BY avg_delay_days DESC;