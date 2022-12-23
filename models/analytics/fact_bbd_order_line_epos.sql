WITH 
  fact_bbd_order_line_epos__source as (
    SELECT
      *
    FROM 
      `ductran.NIQ_Raw.BBD_EPOS`
    ),
  fact_bbd_order_line_epos__rename_column as (
    SELECT
      lazada_sku as product_key
      ,item_sold as unit_sales
      ,week_number as week_num
    FROM
      fact_bbd_order_line_epos__source
    ),
  fact_bbd_order_line_epos__cast_type as (
    SELECT 
      CAST(product_key AS STRING) as product_key
      ,CAST(unit_sales as NUMERIC) as unit_sales
      ,CAST(week_num AS INTEGER) as week_num
    FROM
      fact_bbd_order_line_epos__rename_column
    ),
  fact_bbd_order_line_epos__handle_null as (
    SELECT
      COALESCE(product_key, 'Undefined') AS product_key
      ,COALESCE(unit_sales, 0) AS unit_sales
      ,COALESCE(week_num, 0) AS week_num
    FROM
      fact_bbd_order_line_epos__cast_type
  )

SELECT 
  fact_epos.product_key
  ,fact_epos.unit_sales
  ,fact_epos.week_num
  ,COALESCE(dim_date_ea.month_num,-1) as month_num
  ,'vn.lazada' as retailer
FROM
  fact_bbd_order_line_epos__handle_null as fact_epos
LEFT JOIN
  {{ref('stg_dim_date_ea')}} as dim_date_ea
ON 
  fact_epos.week_num = dim_date_ea.week_num