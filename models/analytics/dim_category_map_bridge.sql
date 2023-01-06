WITH dim_category_map_bridge__depth_0 as (
  SELECT
    category_key as parent_category_key
    ,category_key as child_category_key
    ,category_level as parent_category_level
    ,category_key - category_key AS dept_from_parent
  FROM `ductran.wide_world_importers_dwh.dim_external_category`
  WHERE category_key <> 0
  ),
  dim_category_map_bridge__depth_1 as (
  SELECT
    category_key as child_category_key
    ,parent_category_key 
    ,1 AS dept_from_parent
  FROM `ductran.wide_world_importers_dwh.dim_external_category`
  WHERE category_key <> 0 AND parent_category_key <> 0
  ),
  dim_category_map_bridge__depth_2 as (
  SELECT 
    dept_1.child_category_key as child_category_key
    ,stg.parent_category_key as parent_category_key
    ,2 AS dept_from_parent
  FROM dim_category_map_bridge__depth_1 as dept_1
  LEFT JOIN `ductran.wide_world_importers_dwh.dim_external_category` as stg
  ON dept_1.parent_category_key = stg.category_key
  WHERE stg.parent_category_key <>0
  ),
  dim_category_map_bridge__depth_3 as (
  SELECT 
    dept_2.child_category_key as child_category_key
    ,stg.parent_category_key as parent_category_key
    ,3 AS dept_from_parent
  FROM dim_category_map_bridge__depth_2 as dept_2
  LEFT JOIN `ductran.wide_world_importers_dwh.dim_external_category` as stg
  ON dept_2.parent_category_key = stg.category_key
  WHERE stg.parent_category_key <>0
  ),
  dim_category_map_bridge__enrich as (
  SELECT 
    child_category_key
    ,parent_category_key
    ,dept_from_parent
  FROM
    dim_category_map_bridge__depth_0
  UNION ALL
  SELECT 
    child_category_key
    ,parent_category_key
    ,dept_from_parent
  FROM
    dim_category_map_bridge__depth_1
  UNION ALL
  SELECT 
    child_category_key
    ,parent_category_key
    ,dept_from_parent
  FROM
    dim_category_map_bridge__depth_2
  UNION ALL
  SELECT 
    child_category_key
    ,parent_category_key
    ,dept_from_parent
  FROM
    dim_category_map_bridge__depth_3
  ),
  dim_category_map_bridge__name as (
  SELECT
    enrich.child_category_key as child_category_key
    ,sources_child.category_name as child_category_name
    ,enrich.parent_category_key as parent_category_key
    ,sources_parent.category_name as parent_category_name
    ,sources_parent.category_level as parent_category_level
    ,enrich.dept_from_parent as dept_from_parent
  FROM
    dim_category_map_bridge__enrich as enrich
  LEFT JOIN
    `ductran.wide_world_importers_dwh.dim_external_category` as sources_child
  ON
    enrich.child_category_key = sources_child.category_key
  LEFT JOIN
    `ductran.wide_world_importers_dwh.dim_external_category` as sources_parent
  ON
    enrich.parent_category_key = sources_parent.category_key
  )

SELECT
  parent_category_key
  ,parent_category_name
  ,child_category_key
  ,child_category_name
  ,parent_category_level
  ,dept_from_parent
FROM
  dim_category_map_bridge__name
