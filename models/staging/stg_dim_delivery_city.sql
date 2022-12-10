WITH
  dim_delivery_city__source AS (
    SELECT *
    FROM `vit-lam-data.wide_world_importers.application__cities`
  ),
  dim_delivery_city__rename_column AS (
    SELECT
      city_id as delivery_city_key
      ,city_name
    FROM
      dim_delivery_city__source
  ),
  dim_delivery_city__cast_type AS (
    SELECT
      CAST(delivery_city_key as INTEGER) as delivery_city_key
      ,CAST(city_name as STRING) as city_name
    FROM
      dim_delivery_city__rename_column
  ),
  dim_delivery_city__add_undefined_record AS (
    SELECT
      delivery_city_key
      ,city_name
    FROM
      dim_delivery_city__cast_type
    Union all
    SELECT
      0 as delivery_city_key
      ,'Undefined' as city_name
  )

SELECT
  delivery_city_key
  ,city_name
FROM
  dim_delivery_city__add_undefined_record