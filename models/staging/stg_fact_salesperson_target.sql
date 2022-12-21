WITH 
  fact_salesperson_target__sources as (
    SELECT
      *
    FROM 
      `vit-lam-data.wide_world_importers.external__salesperson_target`
    ),
  fact_salesperson_target__rename_column as (
    SELECT
      salesperson_person_id as salesperson_person_key
      ,DATE_TRUNC(year_month, MONTH) AS year_month
      ,target_revenue
    FROM
      fact_salesperson_target__sources
    ),
  fact_salesperson_target__cast_type as (
    SELECT 
      CAST(salesperson_person_key AS INTEGER) as salesperson_person_key
      ,CAST(year_month as DATE) as year_month
      ,CAST(target_revenue AS INTEGER) as target_revenue
    FROM
      fact_salesperson_target__rename_column
    ),
  fact_salesperson_target__handle_null as (
    SELECT
      COALESCE(salesperson_person_key, 0) AS salesperson_person_key
      ,year_month
      ,COALESCE(target_revenue, 0) AS target_revenue
    FROM
      fact_salesperson_target__cast_type
  )

SELECT 
  salesperson_person_key
  ,year_month
  ,target_revenue
FROM
  fact_salesperson_target__handle_null
