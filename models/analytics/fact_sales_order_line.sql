WITH 
  fact_sales_order_lines__source as (
  SELECT
    *
  FROM 
    `vit-lam-data.wide_world_importers.sales__order_lines`
  ),
  fact_sales_order_lines__rename_col as (
  SELECT
    order_line_id as sales_order_line_key,
    quantity,
    unit_price,
    stock_item_id as product_key
  FROM
    fact_sales_order_lines__source
  ),
  fact_sales_order_lines__cast as (
  SELECT 
    CAST(sales_order_line_key AS INTEGER) as sales_order_line_key,
    CAST(quantity AS INTEGER) as quantity,
    CAST(unit_price AS NUMERIC) as unit_price,
    CAST(product_key AS INTEGER) as product_key
  FROM
    fact_sales_order_lines__rename_col
)
SELECT
  *,
  quantity*unit_price as gross_amount,
FROM
  fact_sales_order_lines__cast