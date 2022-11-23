WITH dim_supplier_source as 
(
  SELECT 
  *
  FROM 
  `vit-lam-data.wide_world_importers.purchasing__suppliers`
),
  dim_supplier_rename AS 
(
  SELECT
  supplier_id AS supplier_key,
  supplier_name
  FROM
  dim_supplier_source
),
  dim_supplier_cast AS
(
  SELECT
  CAST(supplier_key AS INTEGER) as supplier_key,
  CAST(supplier_name AS STRING) as supplier_name
  FROM
  dim_supplier_rename
)
SELECT 
  supplier_key,
  supplier_name
FROM dim_supplier_cast
