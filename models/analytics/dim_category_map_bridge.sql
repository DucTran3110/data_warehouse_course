WITH dim_category_map_bridge__depth_0 as (
  SELECT
    category_key as parent_category_key
    ,category_key as child_category_key
    ,category_key - category_key AS dept_from_parent
  FROM `ductran.wide_world_importers_dwh.dim_external_category`
  WHERE category_key <> 0
  ),
  dim_category_map_bridge__depth_1 as (
  SELECT
    category_key as child_category_key
    ,parent_category_key 
    ,category_key - parent_category_key AS dept_from_parent
  FROM `ductran.wide_world_importers_dwh.dim_external_category`
  WHERE category_key <> 0 AND parent_category_key <> 0
  ),
  dim_category_map_bridge__depth_2 as (
  SELECT 
    dept_1.child_category_key as child_category_key
    ,stg.parent_category_key as parent_category_key
    ,dept_1.child_category_key - stg.parent_category_key AS dept_from_parent
  FROM dim_category_map_bridge__depth_1 as dept_1
  LEFT JOIN `ductran.wide_world_importers_dwh.dim_external_category` as stg
  ON dept_1.parent_category_key = stg.category_key
  WHERE stg.parent_category_key <>0
  ),
  dim_category_map_bridge__depth_3 as (
  SELECT 
    dept_2.child_category_key as child_category_key
    ,stg.parent_category_key as parent_category_key
    ,dept_2.child_category_key - stg.parent_category_key AS dept_from_parent
  FROM dim_category_map_bridge__depth_2 as dept_2
  LEFT JOIN `ductran.wide_world_importers_dwh.dim_external_category` as stg
  ON dept_2.parent_category_key = stg.category_key
  WHERE stg.parent_category_key <>0
  )

SELECT 
  child_category_key
  ,parent_category_key
  ,dept_from_parent
FROM
  dim_category_map_bridge__depth_3
