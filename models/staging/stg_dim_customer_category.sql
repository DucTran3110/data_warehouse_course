WITH
  dim_customer_category__source AS(
    SELECT *
    FROM `vit-lam-data.wide_world_importers.sales__customer_categories`
  ),
  dim_customer_category__rename AS(
    SELECT 
      customer_category_id as customer_category_key
      , customer_category_name
    FROM
      dim_customer_category__source
  ),
  dim_customer_category__cast AS(
    SELECT
      CAST(customer_category_key as INTEGER) as customer_category_key
      , CAST(customer_category_name as STRING) as customer_category_name
    FROM
      dim_customer_category__rename
  )

SELECT
  customer_category_key
  , customer_category_name
FROM
  dim_customer_category__cast
