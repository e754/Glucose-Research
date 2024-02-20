CREATE TABLE `db_name.my_MIMIC.onlyGlucose_chart` AS
select * from `physionet-data.mimiciv_icu.chartevents` where itemid IN (220621, 228388, 225664,226537);
-- 220621 --> Glucose (serum)
-- 225664 --> Glucose finger stick (range 70-100)
-- 226537 --> Glucose (whole blood)
-- 228388 --> Glucose (whole blood) (soft)

CREATE TABLE `protean-chassis-368116.my_MIMIC.onlyGlucose_bg` AS
SELECT 
    lab.*,
    icu.* EXCEPT(hadm_id) 
    FROM `physionet-data.mimiciv_hosp.labevents` AS lab

LEFT JOIN (
    SELECT hadm_id, stay_id, icu_intime, icu_outtime
    FROM `physionet-data.mimiciv_derived.icustay_detail` 
) AS icu
ON lab.hadm_id = icu.hadm_id

WHERE lab.itemid IN (50809, 52027, 50931, 52569) -- Glucose itemid's 
-- 50809, 52027 --> Blood gas
-- 50931, 52569 --> Chemistry

AND lab.charttime BETWEEN icu.icu_intime AND icu.icu_outtime  -- ensure measurement is within ICU stay
;