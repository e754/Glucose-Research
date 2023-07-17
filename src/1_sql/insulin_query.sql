-- run glucose query first
CREATE OR REPLACE TABLE `glucosedatabyicu.mergingFiltering.17_tobeused` AS (
  SELECT
    a.*,
    IFNULL(CAST(total_insulin_measurements AS FLOAT64) / los, NULL) AS totalinsulin_perLOS
  FROM (
    SELECT
      d.*,
      a.total_insulin_measurements
    FROM (
      SELECT
        stay_id,
        COUNT(*) AS total_insulin_measurements
      FROM
        glucosedatabyicu.measurmentTaken.onlyGlucose
      GROUP BY
        stay_id
    ) a
    JOIN
      `glucosedatabyicu.mergingFiltering.14_revisedtotalgluc` d
    ON
      d.stay_id = a.stay_id
  ) a
  ORDER BY
    a.subject_id
)
