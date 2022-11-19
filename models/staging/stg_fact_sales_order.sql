WITH 
  fact_sales_order__source as (
    SELECT
      *
    FROM 
      `vit-lam-data.wide_world_importers.sales__orders`
    ),
  fact_sales_order__rename_col as (
    SELECT
      order_id as sales_order_key,
      customer_id as customer_key
    FROM
      fact_sales_order__source
    ),
  fact_sales_order__cast as (
    SELECT
      CAST(sales_order_key as INTEGER) as sales_order_key,
      CAST(customer_key as INTEGER) as customer_key
    FROM
      fact_sales_order__rename_col
    )

SELECT
  sales_order_key,
  customer_key
FROM
  fact_sales_order__cast
  