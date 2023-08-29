import os

import pandas as pd
from sklearn.preprocessing import LabelEncoder

#!pip install tableone
from tableone import TableOne, load_dataset

current_path = os.path.abspath(".")
label_encoder = LabelEncoder()
fi = os.path.abspath("../../data/cohorted_data.csv")
print(fi)
data = pd.read_csv(fi)

columns = [
    "gender",
    "age",
    "los",
    "language",
    "admElective",
    "charlson_comorbidity_index",
    "diabetes",
    "SOFA",
    "race_group",
    "hadInsulinDayOne",
    "hadMeasurmentDayOne",
    "cad_present",
    "heart_failure_present",
    "hypertension_present",
    "totalinsulin_perLOS",
    "english_Proficent",
    "methylprednisolone_equivalent_normalized_by_icu_los",
]
cat = [
    "hadInsulinDayOne",
    "hadMeasurmentDayOne",
    "gender",
    "language",
    "admElective",
    "diabetes",
    "cad_present",
    "heart_failure_present",
    "hypertension_present",
    "english_Proficent",
]
limit = {
    "hypertension_present": 1,
    "hadInsulinDayOne": 1,
    "gender": 1,
    "language": 1,
    "admElective": 1,
    "hadMeasurmentDayOne": 1,
    "english_Proficent": 1,
    "diabetes": 1,
}
groupby = ["race_group"]
nonnormal = ["charlson_comorbidity_index", "SOFA", "los", "totalinsulin_perLOS"]
mytable = TableOne(
    data,
    columns=columns,
    categorical=cat,
    groupby=groupby,
    nonnormal=nonnormal,
    limit=limit,
    pval=False,
)
mytable
