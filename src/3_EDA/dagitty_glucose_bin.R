dag {
"Admission type" [pos="-0.533,-0.885"]
"Anchor Year" [pos="-0.600,-0.482"]
"English Proficiency" [pos="-1.922,0.372"]
"Fluids/Meds" [pos="-0.010,-1.472"]
"Glucose measured y/n" [outcome,pos="0.719,0.155"]
"Insurance type" [pos="-1.681,-0.457"]
"Lab values" [pos="0.582,-1.358"]
Age [pos="-1.275,-0.575"]
Asthma [pos="0.948,0.927"]
CCI [pos="-0.761,0.530"]
COPD [pos="1.227,0.617"]
Comorbidities [pos="-0.141,0.854"]
Demographics [exposure,pos="-1.337,0.162"]
Diabetes [pos="1.331,0.801"]
Glucocorticoids [pos="1.141,-1.253"]
Insulin [pos="1.375,0.085"]
Race [pos="-2.025,0.110"]
SOFA [pos="0.069,-1.080"]
Sex [pos="-1.984,-0.123"]
Surgery [pos="-0.318,-1.257"]
Vitals [pos="0.334,-1.510"]
"Admission type" -> "Glucose measured y/n"
"Anchor Year" -> "Glucose measured y/n"
"English Proficiency" -> Demographics
"Fluids/Meds" -> SOFA
"Glucose measured y/n" -> Insulin
"Insurance type" -> Demographics
"Lab values" -> SOFA
Age -> Demographics
Asthma -> Comorbidities
Asthma -> Glucocorticoids
CCI -> Comorbidities
COPD -> Comorbidities
COPD -> Glucocorticoids
Comorbidities -> "Glucose measured y/n"
Demographics -> "Glucose measured y/n"
Diabetes -> Comorbidities
Diabetes -> Glucocorticoids
Glucocorticoids -> "Glucose measured y/n"
Race -> Demographics
SOFA -> "Glucose measured y/n"
Sex -> Demographics
Surgery -> "Glucose measured y/n"
Vitals -> SOFA
}
