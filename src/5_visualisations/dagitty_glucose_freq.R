dag {
"Admission type" [pos="-0.533,-0.885"]
"Anchor Year" [pos="-0.600,-0.482"]
"English Proficiency" [pos="-2.011,0.409"]
"Glucose frequency" [outcome,pos="0.719,0.155"]
"Glucose measured" [pos="-0.248,0.464"]
"Insurance type" [pos="-1.681,-0.457"]
"Lab values" [pos="0.684,-1.000"]
"SOFA components" [pos="0.281,-1.573"]
Age [pos="-1.275,-0.575"]
Asthma [pos="0.948,0.927"]
CCI [pos="-0.761,0.530"]
COPD [pos="1.227,0.617"]
Comorbidities [pos="-0.141,0.854"]
Demographics [exposure,pos="-1.337,0.162"]
Diabetes [pos="1.327,0.923"]
Fluids [pos="-0.100,-1.525"]
Glucocorticoids [pos="1.141,-1.253"]
Insulin [pos="-0.409,0.315"]
Race [pos="-2.025,0.110"]
SOFA [pos="0.069,-1.080"]
Sex [pos="-1.984,-0.123"]
Surgery [pos="-0.318,-1.257"]
Vitals [pos="0.582,-1.337"]
"Admission type" -> "Glucose frequency"
"Anchor Year" -> "Glucose frequency"
"English Proficiency" -> Demographics
"Glucose frequency" <-> "Glucose measured"
"Insurance type" -> Demographics
"Lab values" -> "Glucose frequency"
"Lab values" -> SOFA
"SOFA components" -> SOFA
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
Fluids -> SOFA
Glucocorticoids -> "Glucose frequency"
Insulin -> "Glucose frequency"
Race -> Demographics
SOFA -> "Glucose frequency"
Sex -> Demographics
Surgery -> "Glucose frequency"
Vitals -> SOFA
}
