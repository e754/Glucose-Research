

CREATE OR REPLACE TABLE XXXXX.my_MIMIC.aux_steroids AS

WITH aux_steroid AS (
  SELECT
      emar.subject_id
    , emar.hadm_id
    , emar.emar_id
    , medication
    , dose_given
    , emar.charttime
    , icu.icu_intime
    , icu.icu_outtime
    , icu.los_icu
  ,CASE
      WHEN medication = 'Dexamethasone' THEN CAST(dose_given AS DECIMAL) * 5
      WHEN medication = 'Hydrocortisone' THEN CAST(dose_given AS DECIMAL) * 0.2
      WHEN medication = 'Hydrocortisone Na Succ.' THEN CAST(dose_given AS DECIMAL) * 0.2
      WHEN medication = 'INV-Dexamethasone' THEN CAST(dose_given AS DECIMAL) * 5
      WHEN medication = 'MethylPREDNISolone Sodium Succ' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'Methylprednisolone' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'Methylprednisolone ACETATE' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'Methylprednisolone Na Succ Desensitization' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'PredniSONE' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'Prednisone' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'dexamethasone' THEN CAST(dose_given AS DECIMAL) * 5
      WHEN medication = 'hydrocorTISone' THEN CAST(dose_given AS DECIMAL) * 0.2
      WHEN medication = 'hydrocorTISone Sod Succ (PF)' THEN CAST(dose_given AS DECIMAL) * 0.2
      WHEN medication = 'hydrocorTISone Sod Succinate' THEN CAST(dose_given AS DECIMAL) * 0.2
      WHEN medication = 'hydrocortisone-acetic acid' THEN CAST(dose_given AS DECIMAL) * 0.2
      WHEN medication = 'methylPREDNISolone acetate' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'predniSONE' THEN CAST(dose_given AS DECIMAL) * 1
      WHEN medication = 'predniSONE Intensol' THEN CAST(dose_given AS DECIMAL) * 1
  END AS methylprednisolone_equivalent


  FROM `physionet-data.mimiciv_hosp.emar` emar 

  LEFT JOIN `physionet-data.mimiciv_hosp.emar_detail` AS detail
  ON emar.emar_id = detail.emar_id

  LEFT JOIN `physionet-data.mimiciv_derived.icustay_detail` icu
  ON emar.hadm_id = icu.hadm_id 


  WHERE medication IN (
  'Dexamethasone',
  'Hydrocortisone',
  'Hydrocortisone Na Succ.',
  'INV-Dexamethasone',
  'MethylPREDNISolone Sodium Succ',
  'Methylprednisolone',
  'Methylprednisolone ACETATE',
  'Methylprednisolone Na Succ Desensitization',
  'PredniSONE',
  'Prednisone',
  'dexamethasone',
  'hydrocorTISone',
  'hydrocorTISone Sod Succ (PF)',
  'hydrocorTISone Sod Succinate',
  'hydrocortisone-acetic acid',
  'methylPREDNISolone acetate',
  'predniSONE',
  'predniSONE Intensol'
  )
  AND event_txt IN (
  'Delayed Administered',
  'Administered in Other Location',
  'Documented in O.R. Holding',
  'Partial Administered',
  'Delayed Started',
  'Confirmed',
  'Administered',
  'Started',
  'Restarted'
  )
  AND detail.dose_given <> "_"
  AND detail.dose_given <> "___"
  AND TIMESTAMP_DIFF(icu_outtime, charttime, HOUR) > 0
  AND TIMESTAMP_DIFF(charttime, icu_intime, HOUR) > 0

)

SELECT
    hadm_id
  , SUM(methylprednisolone_equivalent) AS methylprednisolone_equivalent_total
  , SUM(methylprednisolone_equivalent)/MAX(los_icu) AS methylprednisolone_equivalent_normalized_by_icu_los

FROM aux_steroid

GROUP BY hadm_id
