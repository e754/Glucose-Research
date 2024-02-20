import os

import numpy as np
import pandas as pd


def get_demo(a):
    print(f"black : {100*len(a[a['race_group']=='Black'])/len(a)}%")
    print(f"asian : {100*len(a[a['race_group']=='Asian'])/len(a)}%")
    print(f"white : {100*len(a[a['race_group']=='White'])/len(a)}%")
    print(f"Hispanic : {100*len(a[a['race_group']=='Asian'])/len(a)}%")
    print(f"Other race groups : {100*len(a[a['race_group']=='Other'])/len(a)}%")
    print(f"Females : {100*len(a[a['gender']=='F'])/len(a)}%")


df = pd.read_csv("data/MIMIC.csv")

df["isMale"] = 0
df.loc[df["gender"] == "M", "isMale"] = 1


def ckdStage(ckd):
    return 1 if ckd >= 3 else 0


df["ckd_stages"] = df["ckd_stages"].apply(ckdStage)


def englishProf(language):
    return 1 if language == "ENGLISH" else 0


df["english_Proficent"] = df["language"].apply(englishProf)


def diabetes(diab):
    if diab == 1 or diab == 2:
        return 1
    else:
        return 0


df["diabetes"] = df["diabetes_types"].apply(diabetes)


def otherRace(race):
    if race == "OTHER":
        return "Other"
    else:
        return race


df["race_group"] = df["race_group"].apply(otherRace)

get_demo(df)

ageTrim = df[df["age"] > 18]
removed = df[df["age"] <= 18]
print(f"After removing those 18 or younger: {len(ageTrim)}")
get_demo(ageTrim)

removed = ageTrim[ageTrim["sepsis3"] != 1]
sepTrim = ageTrim[ageTrim["sepsis3"] == 1]
print(f"After removing those without sepsis:{len(sepTrim)}")
get_demo(sepTrim)

losTrim = sepTrim[sepTrim["los"] > 1]
removed = sepTrim[sepTrim["los"] <= 1]
print(f"After removing those who stayed less than 1 day:{len(losTrim)}")
get_demo(losTrim)

dka_removed = losTrim[losTrim["dka_present"] != 1]
dka = losTrim[losTrim["dka_present"] == 1]
print(f"After removing those with a DKA diagnosis:{len(dka_removed)}")
get_demo(dka_removed)

df = dka_removed[dka_removed["race_group"] != "Other"]
removed = dka_removed[dka_removed["race_group"] == "Other"]
print(f"After removing those with race other:{len(df)}")
get_demo(df)


# Data cleaning, removing inplausible values
df["totalinsulin_perLOS"] = df["totalinsulin_perLOS"].apply(
    lambda x: 300 if x > 300 else x
)

# po2 range
df["po2_min"] = df["po2_min"].apply(lambda x: 0 if x < 0 else x)
df["po2_min"] = df["po2_min"].apply(lambda x: 0 if x > 1000 else x)
df["po2_min"] = df["po2_min"].apply(lambda x: 90 if x == 0 or pd.isna(x) else x)

# pH is within its physiological range
df["ph_min"] = df["ph_min"].apply(lambda x: 0 if x < 5 else x)
df["ph_min"] = df["ph_min"].apply(lambda x: 0 if x > 10 else x)
df["ph_min"] = df["ph_min"].apply(lambda x: 7.35 if x == 0 or pd.isna(x) else x)

# Respiratory rate
df["resp_rate_mean"] = df["resp_rate_mean"].apply(lambda x: 0 if x < 0 else x)
df["resp_rate_mean"] = df["resp_rate_mean"].apply(lambda x: 0 if x > 50 else x)
df["resp_rate_mean"] = df["resp_rate_mean"].apply(
    lambda x: 15 if x == 0 or pd.isna(x) else x
)

# Heart rate
df["heart_rate_mean"] = df["heart_rate_mean"].apply(lambda x: 0 if x < 0 else x)
df["heart_rate_mean"] = df["heart_rate_mean"].apply(lambda x: 0 if x > 250 else x)
df["heart_rate_mean"] = df["heart_rate_mean"].apply(
    lambda x: 90 if x == 0 or pd.isna(x) else x
)

# MBP
df["mbp_mean"] = df["mbp_mean"].apply(lambda x: 0 if x < 0 else x)
df["mbp_mean"] = df["mbp_mean"].apply(lambda x: 0 if x > 200 else x)
df["mbp_mean"] = df["mbp_mean"].apply(lambda x: 85 if x == 0 or pd.isna(x) else x)

# cleansing temperature_mean
df["temperature_mean"] = df["temperature_mean"].apply(lambda x: 0 if x < 32 else x)
df["temperature_mean"] = df["temperature_mean"].apply(lambda x: 0 if x > 45 else x)
df["temperature_mean"] = df["temperature_mean"].apply(
    lambda x: 36.5 if x == 0 or pd.isna(x) else x
)

# Change TRUE to 1
# correct typo
df["measurement_before"] = df["measurment_before"].replace(True, 1)

# Fill in NaN in measurement_before with 0
df["measurement_before"].fillna(0, inplace=True)

# normalize measurement by LOS
df["total_gluc_measr_per_los_bg"] = df["total_glucose_measurements_lab"] / df["los"]

df["total_gluc_measr_per_los_chart"] = (
    df["total_glucose_measurements_chart"] / df["los"]
)

# create rate beyond day 1 per reviewer's request
df["measurement_rate_beyond_d1"] = np.where(
    df["hadMeasurmentDayOne_chart"] == 1,
    df["total_gluc_measr_per_los_bg"],
    0,
)

df["measurement_beyond_d1"] = np.where(df["measurement_rate_beyond_d1"] > 0, 1, 0)

# Save DataFrame to a CSV file
df.to_csv("data/cohorted_data.csv", index=False)
