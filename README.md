# Glucose-Research

# MIMIC Access

MIMIC data can be found in PhysioNet, a repository of freely-available medical research data, managed by the MIT Laboratory for Computational Physiology. Due to its sensitive nature, credentialing is required to access both datasets.

Documentation for MIMIC-IV's can be found here: https://mimic.mit.edu/

# How to get data

### 1. Get the Data!

Both MIMIC and eICU data can be found in [PhysioNet](https://physionet.org/), a repository of freely-available medical research data, managed by the MIT Laboratory for Computational Physiology. Due to its sensitive nature, credentialing is required to access both datasets.

Documentation for MIMIC-IV's can be found [here](https://mimic.mit.edu/) and for eICU [here](https://eicu-crd.mit.edu/).

#### Integration with Google Cloud Platform (GCP)

In this section, we explain how to set up GCP and your environment in order to run SQL queries through GCP right from your local Python setting. Follow these steps:

1) Create a Google account if you don't have one and go to [Google Cloud Platform](https://console.cloud.google.com/bigquery)
2) Enable the [BigQuery API](https://console.cloud.google.com/apis/api/bigquery.googleapis.com)
3) Create a [Service Account](https://console.cloud.google.com/iam-admin/serviceaccounts), where you can download your JSON keys
4) Place your JSON keys in the parent folder (for example) of your project
5) Create a .env file with the command `nano .env` or `touch .env` for Mac and Linux users or `echo. >  .env` for Windows.
6) Update your .env file with your ***JSON keys*** path and the ***id*** of your project in BigQuery

Follow the format:

```sh
KEYS_FILE = "../GoogleCloud_keys.json"
PROJECT_ID = "project-id"
```

#### MIMIC-IV

After getting credentialing at PhysioNet, you must sign the data use agreement and connect the database with GCP, either asking for permission or uploading the data to your project. Please note that only MIMIC v2.0 is available at GCP.

Having all the necessary tables for the cohort generation query in your project, run the following command to fetch the data as a dataframe that will be saved as CSV in your local project. Make sure you have all required files and folders

```shell
python3 src/2_cohorts/1_get_data.py --sql "src/1_sql/3_final_dataSelect.sql" --destination "data/MIMIC.csv"
```

### 2. Create cohort

``python3 src/2_cohorts/cohortselection.py``
