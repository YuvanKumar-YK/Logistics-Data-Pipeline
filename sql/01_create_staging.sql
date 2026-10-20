
CREATE SCHEMA IF NOT EXISTS staging;

CREATE OR REPLACE VIEW staging.stg_dataco_supply_chain AS
SELECT
    "Order Id" AS order_id,
    "Order Item Id" AS order_item_id,
    "Order Customer Id" AS customer_id,

    "Product Card Id" AS product_id,
    "Category Id" AS category_id,
    "Category Name" AS category_name,
    "Department Name" AS department_name,

    "Order Status" AS order_status,
    "Delivery Status" AS delivery_status,
    "Shipping Mode" AS shipping_mode,
    "Late_delivery_risk" AS late_delivery_risk,

    TO_TIMESTAMP("order date (DateOrders)", 'MM/DD/YYYY HH24:MI')::timestamp without time zone AS order_date,
    TO_TIMESTAMP("shipping date (DateOrders)", 'MM/DD/YYYY HH24:MI')::timestamp without time zone AS shipping_date,

    "Days for shipping (real)" AS actual_shipping_days,
    "Days for shipment (scheduled)" AS scheduled_shipping_days,

    "Order Item Quantity" AS quantity,
    "Product Price" AS product_price,
    "Order Item Total" AS order_item_total,
    "Sales" AS sales,
    "Order Profit Per Order" AS profit_per_order,
    "Benefit per order" AS benefit_per_order,
    "Order Item Discount" AS item_discount,

    "Market" AS market,
    "Order Region" AS order_region,
    "Order Country" AS order_country,
    "Order State" AS order_state,
    "Order City" AS order_city,

    "Customer Segment" AS customer_segment,
    "Customer Country" AS customer_country,
    "Customer State" AS customer_state,
    "Customer City" AS customer_city

FROM raw.dataco_supply_chain;
