WITH 
  fact_purchase_order__source as (
    SELECT
      *
    FROM 
      `vit-lam-data.wide_world_importers.purchasing__purchase_orders`
    ),
  fact_purchase_order__rename_column as (
    SELECT
      purchase_order_id as purchase_order_key
      , supplier_id as supplier_key
      , delivery_method_id as delivery_method_key
      , contact_person_id as contact_person_key
      , order_date
      , expected_delivery_date
      , supplier_reference
      , is_order_finalized
    FROM
      fact_purchase_order__source
    ),
  fact_purchase_order__cast_type as (
    SELECT
      CAST(purchase_order_key as INTEGER) as purchase_order_key
      ,CAST(supplier_key as INTEGER) as supplier_key
      ,CAST(delivery_method_key as INTEGER) as delivery_method_key
      ,CAST(contact_person_key as INTEGER) as contact_person_key
      ,CAST(order_date as Date) as order_date
      ,CAST(expected_delivery_date as Date) as expected_delivery_date
      ,CAST(supplier_reference as STRING) as supplier_reference
      ,CAST(is_order_finalized as BOOLEAN) as is_order_finalized
    FROM
      fact_purchase_order__rename_column
    ),
  fact_purchase_order__convert_boolean as (
    SELECT
       purchase_order_key
      ,supplier_key
      ,delivery_method_key
      ,contact_person_key
      ,order_date
      ,expected_delivery_date
      ,supplier_reference
      ,CASE 
      WHEN is_order_finalized is true THEN 'Order is Finalized'
      WHEN is_order_finalized is false THEN 'Order is not Finalized'
      END AS is_order_finalized
    FROM 
      fact_purchase_order__cast_type
  ),
  fact_purchase_order__handle_null as (
    SELECT
      purchase_order_key
      ,supplier_key
      ,delivery_method_key
      ,contact_person_key
      ,order_date
      ,expected_delivery_date
      ,COALESCE(supplier_reference,'Undefined') as supplier_reference
      ,is_order_finalized
    FROM
      fact_purchase_order__convert_boolean
  )

SELECT
  fact_purchase_head.purchase_order_key
  ,fact_purchase_head.supplier_key
  ,fact_purchase_head.delivery_method_key
  ,COALESCE(dim_delivery_method.delivery_method_name,'Error') as delivery_method_name
  ,fact_purchase_head.contact_person_key
  ,fact_purchase_head.order_date
  ,fact_purchase_head.expected_delivery_date
  ,fact_purchase_head.supplier_reference
  ,fact_purchase_head.is_order_finalized
FROM
  fact_purchase_order__handle_null AS fact_purchase_head
LEFT JOIN 
  {{ref('stg_dim_delivery_method')}} as dim_delivery_method
ON
  fact_purchase_head.delivery_method_key = dim_delivery_method.delivery_method_key