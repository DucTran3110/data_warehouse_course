WITH 
  fact_bbd_order_line_ea__source as (
    SELECT
      *
    FROM 
      `ductran.NIQ_Raw.BBD_EA`
    ),
  fact_bbd_order_line_ea__rename_column as (
    SELECT
      upc as product_key
      ,Sales_Unit_Month as unit_sales
      ,week as week_num
      ,month as month_num
    FROM
      fact_bbd_order_line_ea__source
    ),
  fact_bbd_order_line_ea__cast_type as (
    SELECT 
      CAST(product_key AS STRING) as product_key
      ,CAST(unit_sales as NUMERIC) as unit_sales
      ,CAST(week_num AS INTEGER) as week_num
      ,CAST(month_num AS INTEGER) as month_num
    FROM
      fact_bbd_order_line_ea__rename_column
    ),
  fact_bbd_order_line_ea__handle_null as (
    SELECT
      COALESCE(product_key, 'Undefined') AS product_key
      ,COALESCE(unit_sales, 0) AS unit_sales
      ,COALESCE(week_num, 0) AS week_num
      ,COALESCE(month_num, 0) AS month_num
    FROM
      fact_bbd_order_line_ea__cast_type
  )

SELECT 
  product_key
  ,unit_sales
  ,week_num
  ,month_num
FROM
  fact_bbd_order_line_ea__handle_null
