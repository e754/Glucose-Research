import pandas as pd
import os
import numpy as np

def get_demo(a):
    print(f"black removed: {len(a[a['race_group']=='Black'])}")
    print(f"asian removed: {len(a[a['race_group']=='Asian'])}")
    print(f"white removed: {len(a[a['race_group']=='White'])}")
    print(f"Hispanic removed: {len(a[a['race_group']=='Asian'])}")
    print(f"Other race groups removed: {len(a[a['race_group']=='Other'])}")
df = pd.read_csv("data/MIMIC.csv")

df['isMale'] = 0
df.loc[df['gender'] == 'M', 'isMale'] = 1

def ckdStage(ckd):
  return 1 if ckd >= 3 else 0
df['ckd_stages'] = df['ckd_stages'].apply(ckdStage)

def englishProf(language):
  return 1 if language =='ENGLISH'  else 0
df['english_Proficent'] = df['language'].apply(englishProf)

def diabetes(diab):
   if diab == 1 or diab == 2:
      return 1
   else:
      return 0
df['diabetes']=df['diabetes_types'].apply(diabetes)

def otherRace(race):
   if race=='OTHER':
      return 'Other'
   else:
      return race
df['race_group']=df['race_group'].apply(otherRace)

ageTrim=df[df['age']>18]
removed=df[df['age']<=18]
print(f"After removing those 18 or younger: {len(ageTrim)}")
get_demo(removed)

removed=ageTrim[ageTrim['sepsis3']!=0]
sepTrim=ageTrim[ageTrim['sepsis3']==1]
print(f"After removing those without sepsis:{len(sepTrim)}")
get_demo(removed)

losTrim=sepTrim[sepTrim['los']>1]
removed=sepTrim[sepTrim['los']<=1]
print(f"After removing those who stayed less than 1 day:{len(losTrim)}")
get_demo(removed)

df=losTrim[losTrim['race_group']!='Other']
df=losTrim[losTrim['race_group']!='Other']
removed=losTrim[losTrim['race_group']=='Other']
print(f"After removing those who stayed less than 1 day:{len(df)}")
get_demo(removed)


# Data cleaning, removing inplausible values
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

#cleansing temperature_mean
df['temperature_mean'] = df['temperature_mean'].apply(lambda x: 0 if x < 32 else x)
df['temperature_mean'] = df['temperature_mean'].apply(lambda x: 0 if x > 45 else x)
df['temperature_mean'] = df['temperature_mean'].apply(lambda x: 36.5 if x == 0 or pd.isna(x) else x)

#fill in NA

# Save DataFrame to a CSV file
df.to_csv('data/cohortedData.csv', index=False)
