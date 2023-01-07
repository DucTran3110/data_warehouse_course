WITH
  dim_external_customer_target__source AS(
    SELECT *
    FROM `vit-lam-data.wide_world_importers.external__customer_target`
  ),
  dim_external_customer_target__rename_column AS(
    SELECT 
      year_month
      ,customer_scope
      ,customer_relation
      ,target_revenue
    FROM
      dim_external_customer_target__source
  ),
  dim_external_customer_target__cast_type AS(
    SELECT
      CAST(year_month as DATE) as year_month
      ,CAST(customer_scope as STRING) as customer_scope
      ,CAST(customer_relation as STRING) as customer_relation
      ,CAST(target_revenue as INTEGER) as target_revenue
    FROM
      dim_external_customer_target__rename_column
  )

SELECT
  year_month
  ,customer_scope
  ,customer_relation
  ,target_revenue
FROM
  dim_external_customer_target__cast_type
