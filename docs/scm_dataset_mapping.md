1. Project purpose
This project builds a data engineering pipeline using the DataCo SMART
Supply Chain dataset. It will transform source order and shipping
records into reliable data for supply-chain reporting.
2. Supply Chain Management (SCM) flow
1. Order placement --- identify orders and order dates.
2. Order items and products --- connect orders to individual items,
   products, and categories.
3. Shipping --- examine shipping modes and shipping dates.
4. Delivery performance --- compare actual and scheduled shipping
   days and analyze delivery status.
5. Business reporting --- summarize orders, sales, profit, and
   delivery performance.
Source limitation: The dataset contains order and shipping records.
It does not necessarily include every real-world operational stage, such
as supplier procurement, warehouse picking, inventory movements, or
proof of delivery. The pipeline must not invent those events.
3. Dataset-to-SCM mapping
  SCM area                Source columns                    Example analysis
  Order                   Order Id,                       Order counts and
                          order date (DateOrders),        order-status
                          Order Status                    distribution
  Order items             Order Item Id,                  Item-level transactions
                          Order Item Quantity,            and quantities
                          Product Card Id                 
  Customer and market     Customer Id, Market,          Regional demand
                          Order Region, Order Country   patterns
  Product                 Category Name, Product Name,  Sales and
                          Product Price                   product-category
                                                            performance
  Shipping                Shipping Mode,                  Shipping patterns
                          shipping date (DateOrders)      
  Delivery                Delivery Status,                Late deliveries and
                          Days for shipping (real),       actual versus scheduled
                          Days for shipment (scheduled)   shipping time
  Financials              Sales, Order Item Total,      Sales and profitability
                      Order Profit Per Order          analysis
Column names above reflect the source dataset explored in Phase 2.
Verify names against the CSV before writing transformations.
4. Planned analytics
- Order performance: number of distinct orders and distribution by
  order status.
- Delivery performance: late-delivery rate and actual versus
  scheduled shipping time.
- Product performance: sales and profit by product and category.
- Regional performance: order counts and sales by country, market,
  or region.
- Shipping performance: compare delivery outcomes across shipping
  modes.
5. Grain and data-quality considerations
- The source contains 180,519 order-item rows and 65,752
  distinct order IDs. A single order can contain multiple items, so
  row counts must not be mislabeled as order counts.
- Order Item Id was unique in the initial exploration.
- Product Description was entirely missing; Order Zipcode was
  mostly missing. Decide whether to exclude or retain these fields
  based on later modeling requirements.
- There were 33,784 rows with negative Order Profit Per Order.
  Investigate their business meaning rather than deleting them
  automatically.
- Late_delivery_risk matched the recorded late-delivery outcome in
  the initial exploration. Do not use it to predict that same outcome,
  because it would leak the answer.
- Customer email and password fields are sensitive. Do not publish
  them in reports, sample exports, documentation, or GitHub.
6. Planned pipeline architecture
Raw CSV → Python ingestion and validation → PostgreSQL → SQL transformations / dbt → Airflow orchestration → Power BI reporting
Tools will be introduced in later project phases. This mapping documents
the intended design; it does not claim that those components have
already been implemented.
7. Phase 3 conclusion
The source dataset can support order, product, shipping, delivery,
regional, sales, and profit analysis. The next phases will implement the
pipeline, preserve data quality, and model the data at appropriate
grains.