WITH
  dim_customer__source AS (
    SELECT
      *
    FROM
      `vit-lam-data.wide_world_importers.sales__customers`
    ),
  dim_customer__rename_col AS (
    SELECT
      customer_id as customer_key
      ,customer_name
      ,customer_category_id as customer_category_key
      ,buying_group_id as buying_group_key
    FROM 
      dim_customer__source
    ),
  dim_customer__cast AS (
    SELECT
      CAST(customer_key AS INTEGER) as customer_key
      ,CAST(customer_name AS STRING) as customer_name
      ,CAST(customer_category_key as INTEGER) as customer_category_key
      ,CAST(buying_group_key as INTEGER) as buying_group_key
    FROM
      dim_customer__rename_col
    )

SELECT
  dim_customer.customer_key
  , dim_customer.customer_name
  , dim_customer.customer_category_key
  , COALESCE(dim_customer.buying_group_key,0) as buying_group_key
  , COALESCE(dim_customer_category.customer_category_name,'Error') as customer_category_name
  , COALESCE(dim_buying_group.buying_group_name,'Error') as buying_group_name
FROM
  dim_customer__cast as dim_customer
LEFT JOIN 
  {{ref('stg_dim_customer_category')}} as dim_customer_category
ON dim_customer.customer_category_key = dim_customer_category.customer_category_key
LEFT JOIN
  {{ref('stg_dim_buying_group')}} as dim_buying_group
ON dim_customer.buying_group_key = dim_buying_group.buying_group_key
