import os

import pandas as pd
from sklearn.preprocessing import LabelEncoder

#!pip install tableone
from tableone import TableOne, load_dataset

# Get the absolute path of the directory of the script
dir_path = os.path.dirname(os.path.realpath(__file__))

# Construct the relative path to the CSV file
file_path = os.path.join(dir_path, "..", "..", "data", "cohorted_data.csv")

# Now you can read the file with pandas
data = pd.read_csv(file_path)

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
    "cad_present",
    "heart_failure_present",
    "hypertension_present",
    "totalinsulin_perLOS",
    "english_Proficent",
    "methylprednisolone_equivalent_normalized_by_icu_los",
    "hadMeasurmentDayOne_chart",
    "hadMeasurmentDayOne_lab",
    "measurement_before",
    "measurement_rate_beyond_d1",
    "measurement_beyond_d1",
]
cat = [
    "hadInsulinDayOne",
    "hadMeasurmentDayOne_chart",
    "hadMeasurmentDayOne_lab",
    "measurement_before",
    "measurement_beyond_d1",
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
    "hadMeasurmentDayOne_chart": 1,
    "hadMeasurmentDayOne_lab": 1,
    "measurement_beyond_d1": 1,
    "english_Proficent": 1,
    "diabetes": 1,
}
groupby = ["race_group"]
nonnormal = [
    "charlson_comorbidity_index",
    "SOFA",
    "los",
    "totalinsulin_perLOS",
    "measurement_rate_beyond_d1",
]
mytable = TableOne(
    data,
    columns=columns,
    categorical=cat,
    groupby=groupby,
    nonnormal=nonnormal,
    limit=limit,
    pval=False,
)

mytable.to_excel("results/1_table1/table1.xlsx")
