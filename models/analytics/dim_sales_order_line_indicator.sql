WITH dim_is_undersupply_backordered AS (
  SELECT DISTINCT
    is_undersupply_backordered
  FROM
    {{ref('stg_fact_sales_order')}}
),
  dim_is_undersupply_backordered__join as (
  SELECT
    *
  FROM 
    dim_is_undersupply_backordered
  CROSS JOIN `ductran.wide_world_importers_dwh.dim_package_type`
)

SELECT 
  is_undersupply_backordered
  ,package_type_key
  ,package_type_name
  ,FARM_FINGERPRINT(
    CONCAT(
    is_undersupply_backordered
    ,package_type_key
    )
    )
    AS sales_order_line_indicator_key
FROM 
  dim_is_undersupply_backordered__join
