-- Cleaning: wind_turbine_20220114
------------------------------------------------------------

-- Remove rows with missing coordinates
SELECT *
FROM wind_turbine_20220114
WHERE xlong IS NOT NULL AND ylat IS NOT NULL;

-- Clean location fields
SELECT *,
       UPPER(t_state) AS t_state_clean,
       INITCAP(t_county) AS t_county_clean
FROM wind_turbine_20220114
WHERE xlong IS NOT NULL AND ylat IS NOT NULL;

-- Clean manufacturer, model, and project
SELECT *,
  CASE 
    WHEN t_manu ILIKE '%general electric%' OR t_manu ILIKE 'ge%' THEN 'GE'
    WHEN TRIM(t_manu) = '' THEN NULL
    ELSE t_manu
  END AS t_manu_clean,
  CASE WHEN TRIM(t_model) = '' THEN NULL ELSE t_model END AS t_model_clean,
  CASE WHEN TRIM(p_name) = '' THEN NULL ELSE p_name END AS p_name_clean
FROM wind_turbine_20220114
WHERE xlong IS NOT NULL AND ylat IS NOT NULL;

-- Clean numeric fields
SELECT *,
  CASE WHEN t_cap < 0 THEN NULL ELSE t_cap END AS t_cap_clean,
  CASE WHEN t_ttlh < 0 THEN NULL ELSE t_ttlh_clean,
  CASE WHEN t_hh < 0 THEN NULL ELSE t_hh END AS t_hh_clean,
  CASE WHEN t_rd < 0 THEN NULL ELSE t_rd END AS t_rd_clean
FROM wind_turbine_20220114
WHERE xlong IS NOT NULL AND ylat IS NOT NULL;

-- Clean date field
SELECT *,
  CASE
    WHEN pg_typeof(t_img_date)::text = 'text' THEN TO_DATE(t_img_date::TEXT, 'MM/DD/YYYY')
    ELSE t_img_date::DATE
  END AS t_img_date_clean
FROM wind_turbine_20220114
WHERE xlong IS NOT NULL AND ylat IS NOT NULL;

------------------------------------------------------------
-- Cleaning: clean_eia923_operators
------------------------------------------------------------

SELECT 
  plant_id,
  TRIM(operator_name) AS operator_name_clean,
  operator_id,
  UPPER(plant_state) AS plant_state_clean,
  year,
  CASE 
    WHEN net_generation_megawatthours::TEXT ~ '^[0-9]+(\.[0-9]+)?$'
    THEN net_generation_megawatthours::NUMERIC
    ELSE NULL
  END AS net_gen_mwh_cleaned
FROM eia923_operators
WHERE operator_id IS NOT NULL;
