SELECT 
  customer_key
  ,CAST(customer_key AS STRING) as customer_relation
  ,'Customer' as customer_scope
FROM
  ductran.wide_world_importers_dwh.dim_customer
UNION ALL
SELECT 
  customer_key
  ,customer_category_name as customer_relation
  ,'Customer Category' as customer_scope
FROM
  ductran.wide_world_importers_dwh.dim_customer