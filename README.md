# Glucose-Research


# MIMIC Access

MIMIC data can be found in PhysioNet, a repository of freely-available medical research data, managed by the MIT Laboratory for Computational Physiology. Due to its sensitive nature, credentialing is required to access both datasets.

Documentation for MIMIC-IV's can be found here: https://mimic.mit.edu/


# How to get data

- Create database in bigquery
- Run the sql code (1_sql)
- Change 'glucosedatabyicu' to own project name
- Run python cohort code (2_cohort)
- Python cohort code will automatically download data as a .csv file

.
