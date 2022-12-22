WITH 
  fact_salesperson_target__gross_amount as (
    SELECT
      DATE_TRUNC(order_date, MONTH) AS year_month
      ,salesperson_person_key
      ,sum(gross_amount) as gross_amount
    FROM 
      {{ref('fact_sales_order_line')}}
    Group by
      year_month
      ,salesperson_person_key
    ),
  fact_salesperson_target__join as (
    SELECT
      year_month
      ,salesperson_person_key
      ,target_revenue
      ,gross_amount
    FROM
      {{ref('stg_fact_salesperson_target')}} as fact_target
    FULL OUTER JOIN 
      fact_salesperson_target__gross_amount as fact_so
    USING (year_month,salesperson_person_key)
  ),
  fact_salesperson_target__calculation as (
    SELECT
      year_month
      ,salesperson_person_key
      ,target_revenue
      ,gross_amount
      ,(gross_amount/Ifnull(target_revenue,0)) as achievement
    FROM
      fact_salesperson_target__join
  )

SELECT 
  *
FROM
  fact_salesperson_target__calculation
