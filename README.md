# Glucose-Research

In the dataprep.py file, the cohorts for the dataframe are decided from Curated Data for Describing Blood Glucose Management in the Intensive Care Unit Data from physionet https://www.physionet.org/content/glucose-management-mimic/1.0.1/.

The selected cohort are patients experiencing sepsis, older than 18 years old, with known ethnicity, and a length of stay greater than one day, the cohort totals to 1952 unique ICU stays.

In the datavisualization.py file, a tableOne is created using the tableone package in python, it shows demographic data such as age, gender, and then mean glucose measurment amount/frequency by days, all groups by ethnicity.


# How to get data

which scripts to run?

run models? whichs scripts?

# Getting Access to Data

MIMIC data can be found in PhysioNet, a repository of freely-available medical research data, managed by the MIT Laboratory for Computational Physiology. Due to its sensitive nature, credentialing is required to access both datasets.

Documentation for MIMIC-IV's can be found here: https://mimic.mit.edu/

.
