WITH dim_category_target__year as (
  SELECT DISTINCT
    year
  FROM
    {{ref('fact_external_category_target')}}
),
dim_category_target__enrich_year as (
  SELECT
    *
  FROM
    {{ref('dim_category_map_bridge')}}
  CROSS JOIN
    dim_category_target__year
)

SELECT
  dim_target.year
  ,dim_map_bridge.parent_category_name
  ,SUM(dim_target.target_revenue) AS target_revenue
FROM
  dim_category_target__enrich_year as dim_map_bridge
LEFT JOIN
  {{ref('fact_external_category_target')}} as dim_target
ON
  dim_map_bridge.child_category_key = dim_target.category_key
GROUP BY
  dim_map_bridge.parent_category_name
  ,dim_target.year
ORDER BY 
  dim_target.year
