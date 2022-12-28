WITH 
  dim_customer_attribute__sources as (
    SELECT
      customer_key
      ,sum(gross_amount) as LT_sales_amount
      ,sum(
        CASE WHEN DATE_TRUNC(order_date,month) = '2016-04-01'
        THEN gross_amount
        ELSE 0
        END) as LM_sales_amount
    FROM
      `ductran.wide_world_importers_dwh.fact_sales_order_line`
    GROUP BY
      customer_key
  ),
  dim_customer_attribute__rank as (
    SELECT
      customer_key
      ,LT_sales_amount
      ,PERCENT_RANK() OVER (ORDER BY LT_sales_amount) AS LT_sales_amount_rank
      ,LM_sales_amount
      ,PERCENT_RANK() OVER (ORDER BY LM_sales_amount) AS LM_sales_amount_rank
    FROM
      dim_customer_attribute__sources
  ),
    dim_customer_attribute__segmentation as (
    SELECT
      customer_key
      ,LT_sales_amount
      ,CASE
        WHEN LT_sales_amount_rank < 0.5 THEN 1
        WHEN LT_sales_amount_rank BETWEEN 0.5 AND 0.75 THEN 2
        WHEN LT_sales_amount_rank > 0.75 THEN 3
        ELSE 0
        END as LT_sales_amount_segmentation
      ,LM_sales_amount
      ,CASE
        WHEN LM_sales_amount_rank < 0.5 THEN 1
        WHEN LM_sales_amount_rank BETWEEN 0.5 AND 0.75 THEN 2
        WHEN LM_sales_amount_rank > 0.75 THEN 3
        ELSE 0
        END as LM_sales_amount_segmentation
    FROM
      dim_customer_attribute__rank
    )

SELECT
  customer_key
  ,LT_sales_amount
  ,LT_sales_amount_segmentation
  ,LM_sales_amount
  ,LM_sales_amount_segmentation
FROM
  dim_customer_attribute__segmentation