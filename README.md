# Glucose-Research

### 1. Get Access to the Data!

MIMIC data can be found in [PhysioNet](https://physionet.org/), a repository of freely-available medical research data, managed by the MIT Laboratory for Computational Physiology. Due to its sensitive nature, credentialing is required to access the dataset.

Documentation for MIMIC-IV can be found [here](https://mimic.mit.edu/).

#### A) Integration with Google Cloud Platform (GCP)

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

7) Copy and paste all the relevant data tables from the physionet-data project to your own project:

- Eg. `physionet-data.mimiciv_derived.icustay_detail` to `project-id.mimiciv_derived.icustay_detail`
- The reason for this akward step is that access to physionet-data is limited to the BigQuery/Google Cloud Webbrowser, while API access is restricted
- Alternatively one can run the SQL queries in the Google Cloud. However, one has to make sure all the table references are correctly changed (eg. `db_name.mimiciv_derived.icustay_detail` to `project-id.mimiciv_derived.icustay_detail`)
- Physionet-data tables accessed for this project:
  - mimiciv_icu.icustays
  - mimiciv_icu.inputevents
  - mimiciv_icu.chartevents
  - mimiciv_hosp.admissions
  - mimiciv_hosp.emar
  - mimiciv_hosp.emar_detail
  - mimiciv_hosp.labevents
  - mimiciv_hosp.services
  - mimiciv_hosp.patients
  - mimiciv_hosp.diagnoses_icd
  - mimiciv_derived.age
  - mimiciv_derived.icustay_detail
  - mimiciv_derived.sepsis3
  - mimiciv_derived.first_day_sofa
  - mimiciv_derived.first_day_bg
  - mimiciv_derived.first_day_vitalsign
  - mimiciv_derived.charlson
  - mimiciv_ed.edstay

#### B) Direct download

Alternatively you can also download all the MIMIC-IV data from PhysioNet on your local machine. However, you will be responsible to create your own local SQL environment.

### 2. Install packages

Make sure you first install all the necessary python packages by runnig this code in your terminal:

```shell
pip3 install -r setup/requirements_py.txt
```

### 3. Download MIMIC-IV Data to your Machine and run Analysis in one step

We tried it to make it simple for you by creating a batch file that runs all the relevant scripts sequentially.
However make sure you have the ICD-9 to ICD-10 mapping table "0_icd9_to_10.csv" present in to your src/1_sql folder, as it will upload the csv file as a table to your BigQuery project "project-id.my_MIMIC.icd9_to_10".
Having **all the necessary tables** for the cohort generation query **in your project on BigQuery**, run the following command to fetch the data as a dataframe that will be saved as CSV in your local project. This step will fail if you did not manually copy/paste the tables from physionet-data to your own BigQuery project! (see point A) 7) above)

```shell
python3 src/2_cohorts/0_batch_file.py
```

### 4. Alternative: Run scripts sequentially

Alternatively you can also run all the scripts in the src folder manually and sequentially which facilitates debugging.
