CREATE OR REPLACE TABLE `glucosedatabyicu.mergingFiltering.18_lab` AS (
  SELECT
    d.*,
    a1.lactate_max,
    a1.ph_min,
    a1.po2_min,
    a2.spo2_mean,
    a2.resp_rate_mean,
    a2.heart_rate_mean,
    a2.temperature_mean,
    a2.mbp_mean
  FROM
    `glucosedatabyicu.mergingFiltering.17_tobeused` d
  JOIN
    `physionet-data.mimiciv_derived.first_day_bg` a1
  ON  d.stay_id = a1.stay_id
  JOIN
    `physionet-data.mimiciv_derived.first_day_vitalsign` a2
  ON  d.stay_id = a2.stay_id
);