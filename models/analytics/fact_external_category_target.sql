WITH
  dim_external_category_target__source AS(
    SELECT *
    FROM `vit-lam-data.wide_world_importers.external__category_target`
  ),
  dim_external_category_target__rename_column AS(
    SELECT 
      year
      ,category_id as category_key
      ,target_revenue
    FROM
      dim_external_category_target__source
  ),
  dim_external_category_target__cast_type AS(
    SELECT
      CAST(year as DATE) as year
      ,CAST(category_key as INTEGER) as category_key
      ,CAST(target_revenue as INTEGER) as target_revenue
    FROM
      dim_external_category_target__rename_column
  )

SELECT
  year
  ,category_key
  ,target_revenue
FROM
  dim_external_category_target__cast_type
