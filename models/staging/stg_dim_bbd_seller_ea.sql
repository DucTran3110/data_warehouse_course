WITH
  dim_bbd_seller_ea__rename_column as (
    SELECT
      upc as product_key
      ,Retailer as retailer
      ,Retailer_detail as retailer_detail
      ,seller
    FROM
      `ductran.NIQ_Raw.BBD_EA_Seller`
  ),
  dim_bbd_seller_ea__cast_type as (
    SELECT
      CAST(product_key AS STRING) as product_key
      ,CAST(retailer AS STRING) AS retailer
      ,CAST(Retailer_detail AS STRING) AS retailer_detail
      ,CAST(seller AS STRING) AS seller
    FROM
      dim_bbd_seller_ea__rename_column
  ),
  dim_bbd_seller_ea__undefined_record as (
    SELECT
      product_key
      ,retailer
      ,retailer_detail
      ,seller
    FROM
      dim_bbd_seller_ea__cast_type
    UNION ALL 
    SELECT
      'Undefined' as product_key
      ,'Undefined' as retailer
      ,'Undefined' as retailer_detail
      ,'Undefined' as seller
  )

SELECT
  product_key
  ,retailer
  ,retailer_detail
  ,seller
FROM
  dim_bbd_seller_ea__undefined_record