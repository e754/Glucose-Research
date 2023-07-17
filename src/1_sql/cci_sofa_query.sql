CREATE OR REPLACE TABLE `glucose-390717.glucose1.sofa_charls_fixed`
AS (
SELECT
  d.*,
  a.sofa,
  a.cardiovascular,
  a.cns,
  a.coagulation,
  a.liver,
  a.renal,
  a.respiration
FROM
  `glucose-390717.glucose1.Charls_added` d
  -- Use MIMICIV Dervied to access table
JOIN
  `evident-zone-390414.MIMICIV_gluc.Sofascore` a 
  --Use MIMIC IV Dervice to access sofa table
ON  d.stay_id = a.stay_id
)