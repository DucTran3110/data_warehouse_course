WITH
  dim_customer__source AS (
    SELECT
      *
    FROM
      `vit-lam-data.wide_world_importers.sales__customers`
    ),
  dim_customer__rename_col AS (
    SELECT
      customer_id as customer_key,
      customer_name
    FROM 
      dim_customer__source
    ),
  dim_customer__cast AS (
    SELECT
      CAST(customer_key AS INTEGER) as customer_key,
      CAST(customer_name AS STRING) as customer_name
    FROM
      dim_customer__rename_col
    )

SELECT
  customer_key,
  customer_name
FROM
  dim_customer__cast