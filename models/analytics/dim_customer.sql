WITH
  dim_customer__source AS (
    SELECT
      *
    FROM
      `vit-lam-data.wide_world_importers.sales__customers`
    ),
  dim_customer__rename_column AS (
    SELECT
      customer_id as customer_key
      ,customer_name
      ,credit_limit
      ,account_opened_date
      ,standard_discount_percentage
      ,is_statement_sent
      ,is_on_credit_hold
      ,payment_days
      ,delivery_run
      ,run_position
      ,delivery_postal_code
      ,postal_postal_code
      ,customer_category_id as customer_category_key
      ,buying_group_id as buying_group_key
      ,delivery_method_id as delivery_method_key
      ,delivery_city_id as delivery_city_key
      ,postal_city_id as postal_city_key
      ,primary_contact_person_id as primary_contact_person_key
      ,alternate_contact_person_id as alternate_contact_person_key
    FROM 
      dim_customer__source
    ),
  dim_customer__cast_type AS (
    SELECT
      CAST(customer_key AS INTEGER) as customer_key
      ,CAST(customer_name AS STRING) as customer_name
      ,CAST(credit_limit as NUMERIC) as credit_limit
      ,CAST(account_opened_date AS DATE) AS account_opened_date
      ,CAST(standard_discount_percentage AS NUMERIC) AS standard_discount_percentage
      ,CAST(is_statement_sent AS BOOLEAN) AS is_statement_sent
      ,CAST(is_on_credit_hold as BOOLEAN) as is_on_credit_hold
      ,CAST(payment_days AS INTEGER) AS payment_days
      ,CAST(delivery_run AS STRING) AS delivery_run
      ,CAST(run_position AS STRING) AS run_position
      ,CAST(delivery_postal_code AS STRING) AS delivery_postal_code
      ,CAST(postal_postal_code AS STRING) AS postal_postal_code
      ,CAST(customer_category_key as INTEGER) as customer_category_key
      ,CAST(buying_group_key as INTEGER) as buying_group_key
      ,CAST(delivery_method_key as INTEGER) as delivery_method_key
      ,CAST(delivery_city_key as INTEGER) as delivery_city_key
      ,CAST(postal_city_key as INTEGER) as postal_city_key
      ,CAST(primary_contact_person_key as INTEGER) as primary_contact_person_key
      ,CAST(alternate_contact_person_key as INTEGER) as alternate_contact_person_key
    FROM
      dim_customer__rename_column
    ),
  dim_customer__convert_boolean AS (
    SELECT
      customer_name
      ,credit_limit
      ,account_opened_date
      ,standard_discount_percentage
      ,CASE
        WHEN is_statement_sent is true then 'Statement Sent'
        WHEN is_statement_sent is false then 'Not Statement Sent'
      END AS is_statement_sent
      ,CASE
        WHEN is_on_credit_hold is true then 'On Credit Hold'
        WHEN is_on_credit_hold is false then 'Not On Credit Hold'
      END AS is_on_credit_hold
      ,payment_days
      ,delivery_run
      ,run_position
      ,delivery_postal_code
      ,postal_postal_code
      ,customer_category_key
      ,buying_group_key
      ,delivery_method_key
      ,delivery_city_key
      ,postal_city_key
      ,primary_contact_person_key
      ,alternate_contact_person_key
    FROM
      dim_customer__cast_type
    ),
  dim_customer__add_undefined_record AS (
    SELECT
      *
    FROM dim_customer__convert_boolean
    UNION ALL
    SELECT
      0 as customer_key
      ,'Undefined' as customer_name
      ,0 as customer_category_key
      ,0 as buying_group_key
      ,'Undefined' as is_on_credit_hold
  )

SELECT
  dim_customer.customer_key
  , dim_customer.customer_name
  , dim_customer.customer_category_key
  , dim_customer.is_on_credit_hold
  , COALESCE(dim_customer.buying_group_key,0) as buying_group_key
  , COALESCE(dim_customer_category.customer_category_name,'Error') as customer_category_name
  , COALESCE(dim_buying_group.buying_group_name,'Error') as buying_group_name
FROM
  dim_customer__add_undefined_record as dim_customer
LEFT JOIN 
  {{ref('stg_dim_customer_category')}} as dim_customer_category
ON dim_customer.customer_category_key = dim_customer_category.customer_category_key
LEFT JOIN
  {{ref('stg_dim_buying_group')}} as dim_buying_group
ON dim_customer.buying_group_key = dim_buying_group.buying_group_key
