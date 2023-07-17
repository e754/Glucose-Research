-- Run first
with aux as (
SELECT 
    subject_id
    , hadm_id
    , CASE
       WHEN icd_version = 9 THEN icd_conv
       ELSE icd_code
      END AS icd_codes
  
  FROM `physionet-data.mimiciv_hosp.diagnoses_icd`
  AS dx
  LEFT JOIN(
    SELECT icd9, icd10 AS icd_conv
    FROM `glucosedatabyicu.my_MIMIC.icd9_to_10`
  )
  AS conv
  ON conv.icd9 = dx.icd_code


),
piv as (
SELECT DISTINCT
    icu.hadm_id,
    adm_dx.pneumonia, adm_dx.uti, adm_dx.biliary, adm_dx.skin,
    adm_dx.clabsi, adm_dx.cauti, adm_dx.ssi, adm_dx.vap


  , CASE WHEN (
       icd_codes LIKE "%I10%"
    OR icd_codes LIKE "%I11%"
    OR icd_codes LIKE "%I12%"
    OR icd_codes LIKE "%I13%"
    OR icd_codes LIKE "%I14%"
    OR icd_codes LIKE "%I15%"
    OR icd_codes LIKE "%I16%"
    OR icd_codes LIKE "%I70%"
  ) THEN 1
    ELSE NULL
  END AS hypertension_present

  , CASE WHEN (
       icd_codes LIKE "%I50%"
    OR icd_codes LIKE "%I110%"
    OR icd_codes LIKE "%I27%"
    OR icd_codes LIKE "%I42%"
    OR icd_codes LIKE "%I43%"
    OR icd_codes LIKE "%I517%"
  ) THEN 1
    ELSE NULL
  END AS heart_failure_present

  , CASE WHEN (
       icd_codes LIKE "%J41%"
    OR icd_codes LIKE "%J42%"
    OR icd_codes LIKE "%J43%"
    OR icd_codes LIKE "%J44%"
    OR icd_codes LIKE "%J45%"
    OR icd_codes LIKE "%J46%"
    OR icd_codes LIKE "%J47%"
  ) THEN 1
    ELSE NULL
  END AS copd_present

  , CASE WHEN 
      icd_codes LIKE "%J841%"
      THEN 1
      ELSE NULL
  END AS asthma_present

  , CASE WHEN (
       icd_codes LIKE "%I20%"
    OR icd_codes LIKE "%I21%"
    OR icd_codes LIKE "%I22%"
    OR icd_codes LIKE "%I23%"
    OR icd_codes LIKE "%I24%"
    OR icd_codes LIKE "%I25%"
  ) THEN 1
    ELSE NULL
  END AS cad_present

  , CASE 
      WHEN icd_codes LIKE "%N181%" THEN 1
      WHEN icd_codes LIKE "%N182%" THEN 2
      WHEN icd_codes LIKE "%N183%" THEN 3
      WHEN icd_codes LIKE "%N184%" THEN 4
      WHEN (
           icd_codes LIKE "%N185%" 
        OR icd_codes LIKE "%N186%"
      )
      THEN 5
    ELSE NULL
  END AS ckd_stages

  , CASE 
      WHEN icd_codes LIKE "%E08%" THEN 1
      WHEN icd_codes LIKE "%E09%" THEN 1
      WHEN icd_codes LIKE "%E10%" THEN 1
      WHEN icd_codes LIKE "%E11%" THEN 2
      WHEN icd_codes LIKE "%E13%" THEN 1
    ELSE NULL
  END AS diabetes_types

-- connective tissue disease as defined in Elixhauser comorbidity score
  , CASE 
      WHEN icd_codes LIKE "%L940" THEN 1
      WHEN icd_codes LIKE "%L941" THEN 1
      WHEN icd_codes LIKE "%L943%" THEN 1
      WHEN icd_codes LIKE "%M05%" THEN 1
      WHEN icd_codes LIKE "%M06%" THEN 1
      WHEN icd_codes LIKE "%M08%" THEN 1
      WHEN icd_codes LIKE "%M120" THEN 1
      WHEN icd_codes LIKE "%M123" THEN 1
      WHEN icd_codes LIKE "%M30%" THEN 1
      WHEN icd_codes LIKE "%M310%" THEN 1
      WHEN icd_codes LIKE "%M311%" THEN 1
      WHEN icd_codes LIKE "%M312%" THEN 1
      WHEN icd_codes LIKE "%M313%" THEN 1
      WHEN icd_codes LIKE "%M32%" THEN 1
      WHEN icd_codes LIKE "%M33%" THEN 1
      WHEN icd_codes LIKE "%M34%" THEN 1
      WHEN icd_codes LIKE "%M35%" THEN 1
      WHEN icd_codes LIKE "%M45%" THEN 1
      WHEN icd_codes LIKE "%M461%" THEN 1
      WHEN icd_codes LIKE "%M468%" THEN 1
      WHEN icd_codes LIKE "%M469%" THEN 1
    ELSE NULL
  END AS connective_disease

FROM `physionet-data.mimiciv_derived.icustay_detail` AS icu

LEFT JOIN(
  SELECT hadm_id, STRING_AGG(icd_codes) AS icd_codes
  FROM aux
  GROUP BY hadm_id
)
AS diagnoses_icd10 
ON diagnoses_icd10.hadm_id = icu.hadm_id

-- Diagnoses upon admission and hospital acquired infections
LEFT JOIN(
 
 WITH inf_s AS (
  SELECT *
  ,CASE 
      WHEN icd_code LIKE "%J09%" THEN 1
      WHEN icd_code LIKE "%J1%" THEN 1
      WHEN icd_code LIKE "%J85%" THEN 1
      WHEN icd_code LIKE "%J86%" THEN 1
      ELSE NULL
  END AS pneumonia

  ,CASE 
      WHEN icd_code LIKE "%N300%" THEN 1
      WHEN icd_code LIKE "%N390%" THEN 1       
      ELSE NULL
  END AS uti

  ,CASE 
      WHEN icd_code LIKE "%K81%" THEN 1
      WHEN icd_code LIKE "%K830%" THEN 1
      WHEN icd_code LIKE "%K851%" THEN 1  
      ELSE NULL
  END AS biliary

  ,CASE      
      WHEN icd_code LIKE "%L0%" THEN 1       
      ELSE NULL
  END AS skin

FROM `physionet-data.mimiciv_hosp.diagnoses_icd` 

WHERE seq_num <= 3 -- only consider top 3 diagnoses for importance
)

, inf_h AS (
  SELECT *
  , CASE 
      WHEN icd_code LIKE "%T80211%" THEN 1
      ELSE NULL
  END AS hospital_clabsi

 , CASE 
      WHEN icd_code LIKE "%T83511%" THEN 1
      ELSE NULL
  END AS hospital_cauti

 , CASE 
      WHEN icd_code LIKE "%T814%" THEN 1
      ELSE NULL
  END AS hospital_ssi

 , CASE 
      WHEN icd_code LIKE "%J95851%" THEN 1
      ELSE NULL
  END AS hospital_vap

FROM `physionet-data.mimiciv_hosp.diagnoses_icd` 

-- here we consider all possible diagnoses
)

-- Group by admission
SELECT DISTINCT inf_s.hadm_id, 
MAX(inf_s.pneumonia) AS pneumonia, MAX(inf_s.uti) AS uti, MAX(inf_s.biliary) AS biliary, MAX(inf_s.skin) AS skin,
MAX(inf_h.hospital_clabsi) AS clabsi, MAX(inf_h.hospital_cauti) AS cauti, MAX(inf_h.hospital_ssi) AS ssi, MAX(inf_h.hospital_vap) AS vap

FROM inf_s

LEFT JOIN inf_h
ON inf_s.hadm_id = inf_h.hadm_id

WHERE COALESCE(pneumonia, uti, biliary, skin) IS NOT NULL 
GROUP BY hadm_id

)
AS adm_dx 
ON adm_dx.hadm_id = icu.hadm_id

)


SELECT 
  icuStay.*, 
  adm.race,
  adm.language,CASE WHEN adm.admission_type = 'ELECTIVE' THEN 'true' ELSE 'false' END AS `admElective`,
  age.age,
  patients.gender, patients.anchor_year_group,
  sep.sepsis3,
  insu.hadInsulinDayOne,
  measu.hadMeasurmentDayOne,
  so.SOFA,
  so.respiration,
  so.coagulation,
  so.liver,
  so.cardiovascular,
  so.cns,
  so.renal,
  cc.diabetes_without_cc,
  cc.diabetes_with_cc,
  cc.charlson_comorbidity_index,
  piv.pneumonia,
  piv.uti,
  piv.biliary,
  piv.skin,
  piv.hypertension_present,
  piv.heart_failure_present,
  piv.copd_present,
  piv.asthma_present,
  piv.cad_present,
  piv.ckd_stages,
  piv.diabetes_types,
  piv.connective_disease,

  CASE 
    WHEN adm.race LIKE '%HISPANIC%' THEN 'Hispanic'
    WHEN adm.race LIKE '%WHITE%' THEN 'White'
    when adm.race like '%ASIAN%' then 'Asian'
    when adm.race like '%PACIFIC ISLANDER%' then 'OTHER'
    when adm.race like '%Middle Eastern%' then 'White'
    when adm.race like '%PORTUGESE%' then 'White'
    when adm.race like '%BLACK%' then 'Black'
    else 'Other'
  END AS race_group

FROM `physionet-data.mimiciv_icu.icustays` icuStay

LEFT JOIN `physionet-data.mimiciv_hosp.admissions` adm 
ON icuStay.hadm_id = adm.hadm_id

LEFT JOIN `physionet-data.mimiciv_derived.age` age 
ON icuStay.hadm_id = age.hadm_id

LEFT JOIN `physionet-data.mimiciv_hosp.patients` patients
ON icuStay.subject_id = patients.subject_id

LEFT JOIN `physionet-data.mimiciv_derived.sepsis3` sep
ON icuStay.stay_id = sep.stay_id

LEFT JOIN `physionet-data.mimiciv_derived.first_day_sofa` so
ON icuStay.stay_id = so.stay_id

LEFT JOIN `physionet-data.mimiciv_derived.charlson` cc
ON icuStay.hadm_id = cc.hadm_id

LEFT JOIN piv piv
ON icuStay.hadm_id = piv.hadm_id

LEFT JOIN (
  SELECT
  stay_id,
  IF(SUM(CASE WHEN daysinceStart = 1 THEN 1 ELSE 0 END) > 0, TRUE, FALSE) AS hadInsulinDayOne
  
  FROM (
    SELECT *,
    TIMESTAMP_DIFF(CAST(starttime AS TIMESTAMP), CAST(intime AS TIMESTAMP), DAY) AS daysinceStart
    FROM (
      SELECT t1.*, t2.intime
      FROM (
        SELECT *
        FROM `physionet-data.mimiciv_icu.inputevents`
        WHERE itemid IN (229299, 229619, 223257, 223258, 223259, 223260, 223261, 223262)
      ) t1
      JOIN `physionet-data.mimiciv_icu.icustays` t2 ON t1.stay_id = t2.stay_id
    )
  )
  GROUP BY stay_id
) as insu
ON icuStay.stay_id = insu.stay_id 

LEFT JOIN (
  SELECT
  stay_id,
  IF(SUM(CASE WHEN daysinceStart = 1 THEN 1 ELSE 0 END) > 0, TRUE, FALSE) AS hadMeasurmentDayOne
  
  FROM (
    SELECT *,
    TIMESTAMP_DIFF(CAST(charttime AS TIMESTAMP), CAST(intime AS TIMESTAMP), DAY) AS daysinceStart
    FROM (
      SELECT t1.*, t2.intime
      FROM (
        SELECT *
        FROM `physionet-data.mimiciv_icu.chartevents`
        where itemid IN (220621, 228388, 225664,226537)
      ) t1
      JOIN `physionet-data.mimiciv_icu.icustays` t2 ON t1.stay_id = t2.stay_id
    )
  )
  GROUP BY stay_id
) as measu
ON icuStay.stay_id = measu.stay_id






