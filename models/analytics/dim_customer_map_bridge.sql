WITH dim_customer_map_bridge__customer as (
  SELECT 
  customer_key
  ,customer_key as customer_relation
  ,'Customer' as customer_scope
FROM
  ductran.wide_world_importers_dwh.dim_customer
),
dim_customer_map_bridge__customer_category as (
  SELECT 
  customer_key
  ,customer_category_key as customer_relation
  ,'Customer Category' as customer_scope
FROM
  ductran.wide_world_importers_dwh.dim_customer
)
SELECT
  customer_scope
  ,customer_relation
  ,customer_key
FROM
  dim_customer_map_bridge__customer
UNION ALL
SELECT
  customer_scope
  ,customer_relation
  ,customer_key
FROM
  dim_customer_map_bridge__customer_category

