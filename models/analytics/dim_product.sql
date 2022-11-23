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
    supplier_id as supplier_key
    FROM dim_product__source
  ),
  dim_product__cast AS (
  SELECT
    CAST(product_key AS INTEGER) AS product_key,
    CAST(product_name AS STRING) AS product_name,
    CAST(brand_name AS STRING) AS brand_name,
    CAST(supplier_key AS INTEGER) AS supplier_key
  FROM dim_product__rename_col
  )
SELECT 
  dim_product.product_key,
  dim_product.product_name,
  dim_product.brand_name,
  dim_supplier.supplier_key,
  dim_supplier.supplier_name
FROM dim_product__cast as dim_product
LEFT JOIN {{ref('dim_supplier')}} as dim_supplier
ON dim_supplier.supplier_key = dim_product.supplier_key