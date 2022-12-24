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
      ,Sales_Unit_Month as unit_sales_ea
      ,week as week_num
      ,month as month_num
    FROM
      fact_bbd_order_line_ea__source
    ),
  fact_bbd_order_line_ea__cast_type as (
    SELECT 
      CAST(product_key AS STRING) as product_key
      ,CAST(unit_sales_ea as NUMERIC) as unit_sales_ea
      ,CAST(week_num AS INTEGER) as week_num
      ,CAST(month_num AS INTEGER) as month_num
    FROM
      fact_bbd_order_line_ea__rename_column
    ),
  fact_bbd_order_line_ea__handle_null as (
    SELECT
      COALESCE(product_key, 'Undefined') AS product_key
      ,COALESCE(unit_sales_ea, 0) AS unit_sales_ea
      ,COALESCE(week_num, 0) AS week_num
      ,COALESCE(month_num, 0) AS month_num
    FROM
      fact_bbd_order_line_ea__cast_type
  )

SELECT 
  fact_bbd_ea.product_key
  ,fact_bbd_ea.unit_sales_ea
  ,fact_bbd_ea.week_num
  ,fact_bbd_ea.month_num
  ,COALESCE(dim_bbd_seller.retailer,'Error') as retailer_ea
FROM
  fact_bbd_order_line_ea__handle_null as fact_bbd_ea
LEFT JOIN
  {{ref('stg_dim_bbd_seller_ea')}} as dim_bbd_seller
ON 
  fact_bbd_ea.product_key = dim_bbd_seller.product_key
WHERE 
  dim_bbd_seller.retailer = 'vn.lazada'