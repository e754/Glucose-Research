import pandas as pd
import os
import numpy as np
df = pd.read_csv("data/MIMIC.csv")


df.head()

ageTrim=df[df['age']>18]
print(f"After removing those 18 or younger: {len(ageTrim)}")

sepTrim=ageTrim[ageTrim['sepsis3']==1]
print(f"After removing those without sepsis:{len(sepTrim)}")

losTrim=sepTrim[sepTrim['los']>1]
print(f"After removing those who stayed less than 1 day:{len(losTrim)}")

df=losTrim[losTrim['race_group']!='OTHER']
df=df[df['race_group']!='Other']
print(f"After removing those who stayed less than 1 day:{len(df)}")

df['totalinsulin_perLOS'] = df['totalinsulin_perLOS'].apply(lambda x: 300 if x > 300 else x)

# po2 range
df['po2_min'] = df['po2_min'].apply(lambda x: 0 if x < 0 else x)
df['po2_min'] = df['po2_min'].apply(lambda x: 0 if x > 1000 else x)
df['po2_min'] = df['po2_min'].apply(lambda x: 90 if x == 0 or pd.isna(x) else x)

# pH is within its physiological range
df['ph_min'] = df['ph_min'].apply(lambda x: 0 if x < 5 else x)
df['ph_min'] = df['ph_min'].apply(lambda x: 0 if x > 10 else x)
df['ph_min'] = df['ph_min'].apply(lambda x: 7.35 if x == 0 or pd.isna(x) else x)

# Respiratory rate
df['resp_rate_mean'] = df['resp_rate_mean'].apply(lambda x: 0 if x < 0 else x)
df['resp_rate_mean'] = df['resp_rate_mean'].apply(lambda x: 0 if x > 50 else x)
df['resp_rate_mean'] = df['resp_rate_mean'].apply(lambda x: 15 if x == 0 or pd.isna(x) else x)

# Heart rate
df['heart_rate_mean'] = df['heart_rate_mean'].apply(lambda x: 0 if x < 0 else x)
df['heart_rate_mean'] = df['heart_rate_mean'].apply(lambda x: 0 if x > 250 else x)
df['heart_rate_mean'] = df['heart_rate_mean'].apply(lambda x: 90 if x == 0 or pd.isna(x) else x)

# MBP
df['mbp_mean'] = df['mbp_mean'].apply(lambda x: 0 if x < 0 else x)
df['mbp_mean'] = df['mbp_mean'].apply(lambda x: 0 if x > 200 else x)
df['mbp_mean'] = df['mbp_mean'].apply(lambda x: 85 if x == 0 or pd.isna(x) else x)

# Temperature
# Convert 'temperature_mean' column to numeric type (ignoring errors)
df['temperature_mean'] = pd.to_numeric(df['temperature_mean'], errors='coerce')

# Apply transformations
def temperature_transformation(x):
    if pd.isna(x) or x == 0:
        return 36.5
    elif isinstance(x, (int, float)):
        if x < 32:
            return 0
        elif x > 45:
            return 0
        else:
            return x
    else:
        return x

df['temperature_mean'] = df['temperature_mean'].apply(temperature_transformation)

# Save DataFrame to a CSV file
df.to_csv('data/cohortedData.csv', index=False)

# Download the CSV file
