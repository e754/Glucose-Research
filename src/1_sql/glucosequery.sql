CREATE OR REPLACE TABLE `glucosedatabyicu.mergingFiltering.14_revisedtotalgluc` AS (
  SELECT
    a.*,
    IFNULL(CAST(total_glucose_measurements AS FLOAT64) / los, NULL) AS totalgluc_perLOS
  FROM (
    SELECT
      d.*,
      a.total_glucose_measurements
    FROM (
      SELECT
        hadm_id,
        COUNT(*) AS total_glucose_measurements
      FROM
        `glucose-390717.glucose1.actual_input_all`
      GROUP BY
        hadm_id
    ) a
    JOIN
      `glucosedatabyicu.mergingFiltering.comb` d
    ON
      d.hadm_id = a.hadm_id
  ) a
  ORDER BY
    a.subject_id
)


  
