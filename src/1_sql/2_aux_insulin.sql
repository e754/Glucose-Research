CREATE OR REPLACE TABLE `db_name.mergingFiltering.17_tobeused` AS (
 
  WITH onlyInsulin AS (
    SELECT *
    FROM evident-zone-390414.mimiciv_icu.inputevents
    WHERE itemid IN (229299, 229619, 223257, 223258, 223259, 223260, 223261, 223262)
  ),
  insulinAmount AS (
    SELECT
      stay_id,
      SUM(amount) AS total_insulin_amount
    FROM onlyInsulin
    GROUP BY stay_id
  ),
  insulinWeight AS (
    SELECT
      stay_id,
      AVG(patientweight) AS avg_weight
    FROM onlyInsulin
    GROUP BY stay_id
  )
  SELECT
    a.*,
    IFNULL(CAST(total_insulin_amount AS FLOAT64) / los, NULL) AS totalinsulin_perLOS,
    b.avg_weight
  FROM (
    SELECT
      d.*,
      a.total_insulin_amount
    FROM insulinAmount a
    RIGHT JOIN `glucosedatabyicu.mergingFiltering.14_revisedtotalgluc` d
    ON d.stay_id = a.stay_id
  ) a
  LEFT JOIN insulinWeight b
  ON a.stay_id = b.stay_id
  ORDER BY a.subject_id
);
