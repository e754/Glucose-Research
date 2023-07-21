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

race=losTrim[losTrim['race_group']!='OTHER']
race=race[race['race_group']!='Other']
print(f"After removing those who stayed less than 1 day:{len(race)}")


# Save DataFrame to a CSV file
race.to_csv('data/cohortedData.csv', index=False)

# Download the CSV file
