WITH dim_product__source as (
  SELECT 
    *
    FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`
  ),
  dim_product__rename_col as (
  SELECT
    stock_item_id as product_key,
    stock_item_name as product_name,
    brand as brand_name,
    supplier_id as supplier_key,
    is_chiller_stock as is_chiller_stock_boolean,
    FROM dim_product__source
  ),
  dim_product__cast AS (
  SELECT
    CAST(product_key AS INTEGER) AS product_key,
    CAST(product_name AS STRING) AS product_name,
    CAST(brand_name AS STRING) AS brand_name,
    CAST(supplier_key AS INTEGER) AS supplier_key,
    CAST(is_chiller_stock_boolean AS BOOLEAN) AS is_chiller_stock_boolean
  FROM dim_product__rename_col
  ),
  dim_product__convert_boolean as (
  SELECT
    product_key
    , product_name
    , brand_name
    , supplier_key
    , CASE 
      WHEN is_chiller_stock_boolean is true THEN 'Chiller Stock'
      WHEN is_chiller_stock_boolean is false THEN 'Not Chiller Stock'
      END AS is_chiller_stock
  FROM dim_product__cast
  )
SELECT 
  dim_product.product_key,
  dim_product.product_name,
  COALESCE(dim_product.brand_name,'Undefined') as brand_name,
  dim_product.is_chiller_stock,
  dim_product.supplier_key,
  COALESCE(dim_supplier.supplier_name,'Error') as supplier_name
FROM dim_product__convert_boolean as dim_product
LEFT JOIN {{ref('dim_supplier')}} as dim_supplier
ON dim_supplier.supplier_key = dim_product.supplier_key