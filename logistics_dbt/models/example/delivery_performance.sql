
{{ config(materialized='view') }}

SELECT
    delivery_status,
    COUNT(*) AS order_item_count,
    COUNT(DISTINCT order_id) AS unique_order_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_items
FROM {{ source('logistics', 'stg_dataco_supply_chain') }}
GROUP BY delivery_status
