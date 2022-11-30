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
      order_id as sales_order_key,
      stock_item_id as product_key
    FROM
      fact_sales_order_lines__source
    ),
  fact_sales_order_lines__cast as (
    SELECT 
      CAST(sales_order_line_key AS INTEGER) as sales_order_line_key,
      CAST(quantity AS INTEGER) as quantity,
      CAST(unit_price AS NUMERIC) as unit_price,
      CAST(sales_order_key AS INTEGER) as sales_order_key,
      CAST(product_key AS INTEGER) as product_key
    FROM
      fact_sales_order_lines__rename_col
    ),
  fact_sales_order_line__calculate_fact as (
    SELECT
      *,
      quantity*unit_price as gross_amount
    FROM
      fact_sales_order_lines__cast
    )

SELECT 
  fact_line.sales_order_line_key
  ,fact_line.quantity
  ,fact_line.unit_price
  ,fact_line.sales_order_key
  ,fact_line.product_key
  ,fact_line.gross_amount
  ,fact_header.customer_key
  ,fact_header.picked_by_person_key
  ,fact_header.order_date
FROM
  fact_sales_order_line__calculate_fact AS fact_line
LEFT JOIN 
  {{ ref('stg_fact_sales_order')}} AS fact_header
ON
  fact_line.sales_order_key = fact_header.sales_order_key
