-- Must run query for glucose before running this query

CREATE OR REPLACE TABLE `glucosedatabyicu.mergingFiltering.includinginsulin`
AS (
  WITH total_insulin AS (
    SELECT hadm_id, SUM(valuenum) AS total_insulin_value
    FROM glucosedatabyicu.measurmentTaken.onlyGlucose
    GROUP BY hadm_id
  ),
  including_insulin AS (
    SELECT
      d.*,
      a.total_insulin_value
    FROM
      `glucosedatabyicu.mergingFiltering.14_revisedtotalgluc` d
    JOIN
      total_insulin a
    ON d.hadm_id = a.hadm_id 
  ),
  total_insulin_per_los AS (
    SELECT
      a.*,
      IFNULL(total_insulin_value / los, NULL) AS totalinsulin_perLOS
    FROM including_insulin a
    ORDER BY a.hadm_id
  )
  SELECT
    d.*,
    a.gender
  FROM
    total_insulin_per_los d
  JOIN
    `physionet-data.mimiciv_hosp.patients` a
  ON d.subject_id = a.subject_id
);
