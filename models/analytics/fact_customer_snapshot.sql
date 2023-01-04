WITH
  fact_customer_snapshot__source as (
    SELECT
      customer_key
      ,DATE_TRUNC(order_date,MONTH) AS year_month
      ,sum(gross_amount) as sales_amount
    FROM
      `ductran.wide_world_importers_dwh.fact_sales_order_line`
    GROUP BY
      customer_key
      ,DATE_TRUNC(order_date,MONTH)
  ),
  dim_year_month as (
    SELECT DISTINCT
      year_month
    FROM
      `ductran.wide_world_importers_dwh.dim_date`
  ),
  dim_customer_key as (
    SELECT DISTINCT
      customer_key
    FROM
      fact_customer_snapshot__source
  ),
  dim_year_month__cross_join as (
    SELECT
      year_month
      ,customer_key
    FROM
      dim_year_month
    CROSS JOIN
      dim_customer_key
    WHERE
      year_month BETWEEN (SELECT MIN(year_month) FROM fact_customer_snapshot__source) and (SELECT MAX(year_month) FROM fact_customer_snapshot__source)
  ),
  fact_customer_snapshot__densed as (
    SELECT
      dim_year_month.year_month
      ,dim_year_month.customer_key
      ,fact_customer_snapshot.sales_amount
    FROM
      dim_year_month__cross_join AS dim_year_month
    LEFT JOIN
      fact_customer_snapshot__source AS fact_customer_snapshot
    ON
      dim_year_month.year_month = fact_customer_snapshot.year_month 
      AND 
      dim_year_month.customer_key = fact_customer_snapshot.customer_key
  ),
  fact_customer_snapshot__lt_sales_amount as (
    SELECT
      year_month
      ,customer_key
      ,sales_amount
      ,SUM(sales_amount) OVER(PARTITION BY customer_key order by year_month) as LT_sales_amount
    FROM
      fact_customer_snapshot__densed
  ),
  fact_customer_snapshot__rank as (
    SELECT
      year_month
      ,customer_key
      ,sales_amount
      ,PERCENT_RANK() OVER (PARTITION BY year_month ORDER BY sales_amount) AS sales_amount_rank
      ,LT_sales_amount
      ,PERCENT_RANK() OVER (PARTITION BY year_month ORDER BY LT_sales_amount) AS LT_sales_amount_rank
    FROM
      fact_customer_snapshot__lt_sales_amount
  ),
    fact_customer_snapshot__segmentation as (
    SELECT
      year_month
      ,customer_key
      ,sales_amount
      ,CASE
        WHEN sales_amount_rank < 0.5 THEN 1
        WHEN sales_amount_rank BETWEEN 0.5 AND 0.75 THEN 2
        WHEN sales_amount_rank > 0.75 THEN 3
        ELSE 0
        END as sales_amount_segmentation
      ,LT_sales_amount
      ,CASE
        WHEN LT_sales_amount_rank < 0.5 THEN 1
        WHEN LT_sales_amount_rank BETWEEN 0.5 AND 0.75 THEN 2
        WHEN LT_sales_amount_rank > 0.75 THEN 3
        ELSE 0
        END as LT_sales_amount_segmentation
    FROM
      fact_customer_snapshot__rank
    )

SELECT
  year_month
  ,customer_key
  ,sales_amount
  ,sales_amount_segmentation
  ,LT_sales_amount
  ,LT_sales_amount_segmentation
FROM
  fact_customer_snapshot__segmentation