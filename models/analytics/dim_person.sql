WITH dim_person__source as 
(
  SELECT 
  *
  FROM 
  `vit-lam-data.wide_world_importers.application__people`
),
  dim_person__rename AS 
(
  SELECT
    person_id AS person_key
    , full_name
  FROM
  dim_person__source
),
  dim_person__cast AS
(
  SELECT
    CAST(person_key AS INTEGER) as person_key
    , CAST(full_name AS STRING) as full_name
  FROM
  dim_person__rename
)

SELECT 
  person_key
  ,full_name
FROM dim_person__cast
UNION ALL
SELECT
  0 as person_key
  ,'Undefined' as full_name
