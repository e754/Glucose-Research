dag {
"Admission type" [pos="-0.533,-0.885"]
"Anchor Year" [pos="-0.600,-0.482"]
"English Proficiency" [pos="-1.912,0.383"]
"Fluids/Meds" [pos="-0.041,-1.438"]
"Glucose frequency" [outcome,pos="0.719,0.155"]
"Glucose measured" [pos="-0.248,0.464"]
"Insurance type" [pos="-1.681,-0.457"]
"Lab values" [pos="0.472,-1.322"]
Age [pos="-1.275,-0.575"]
Asthma [pos="0.948,0.927"]
CCI [pos="-0.761,0.530"]
COPD [pos="1.227,0.617"]
Comorbidities [pos="-0.141,0.854"]
Demographics [exposure,pos="-1.337,0.162"]
Diabetes [pos="1.322,0.837"]
Glucocorticoids [pos="1.141,-1.253"]
Insulin [pos="-0.409,0.315"]
Race [pos="-2.025,0.110"]
SOFA [pos="0.069,-1.080"]
Sex [pos="-1.984,-0.123"]
Surgery [pos="-0.318,-1.257"]
Vitals [pos="0.265,-1.455"]
"Admission type" -> "Glucose frequency"
"Anchor Year" -> "Glucose frequency"
"English Proficiency" -> Demographics
"Fluids/Meds" -> SOFA
"Glucose frequency" <-> "Glucose measured"
"Glucose frequency" <-> Insulin
"Insurance type" -> Demographics
"Lab values" -> SOFA
Age -> Demographics
Asthma -> Comorbidities
Asthma -> Glucocorticoids
CCI -> Comorbidities
COPD -> Comorbidities
COPD -> Glucocorticoids
Comorbidities -> "Glucose frequency"
Demographics -> "Glucose frequency"
Diabetes -> Comorbidities
Diabetes -> Glucocorticoids
Glucocorticoids -> "Glucose frequency"
Race -> Demographics
SOFA -> "Glucose frequency"
Sex -> Demographics
Surgery -> "Glucose frequency"
Vitals -> SOFA
}
