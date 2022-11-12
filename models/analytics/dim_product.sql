SELECT 
  CAST(stock_item_id AS INTEGER) as product_key,
  CAST(stock_item_name AS STRING) as product_name,
  CAST(brand AS STRING) as brand_name 
FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`