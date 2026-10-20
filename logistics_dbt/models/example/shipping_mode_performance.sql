
{{ config(materialized='view') }}

SELECT
    shipping_mode,
    COUNT(*) AS order_item_count,
    COUNT(*) FILTER (
        WHERE delivery_status = 'Late delivery'
    ) AS late_order_item_count,
    ROUND(
        COUNT(*) FILTER (
            WHERE delivery_status = 'Late delivery'
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_percentage,
    ROUND(AVG(actual_shipping_days), 2) AS avg_actual_shipping_days,
    ROUND(AVG(scheduled_shipping_days), 2) AS avg_scheduled_shipping_days
FROM {{ source('logistics', 'stg_dataco_supply_chain') }}
GROUP BY shipping_mode
