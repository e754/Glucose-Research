import os
from dotenv import load_dotenv
from google.cloud import bigquery
from pandas.io import gbq
import pandas as pd
import numpy as np
from argparse import ArgumentParser


def create_icd9_to_10_map(client, project_id):
    KEYS_FILE = os.getenv("KEYS_FILE")
    project_id = os.getenv("PROJECT_ID")
    dept_dt = pd.read_csv("src/1_sql/0_Mapping table icd9_to_10.csv")
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = KEYS_FILE
    dept_dt.to_gbq(
        destination_table="my_MIMIC.icd9_to_10",
        project_id=project_id,
        if_exists="fail",
    )


def create_aux_dataset(client, project_id):
    # Create 'aux' dataset if it doesn't exist
    dataset_id = f"{project_id}.my_test"
    # dataset_id = f"{project_id}.my_MIMIC"
    dataset = bigquery.Dataset(dataset_id)
    dataset.location = "US"
    print(f"Creating dataset {dataset_id}...")
    dataset = client.create_dataset(dataset, exists_ok=True)


def create_aux_tables(
    client,
    project_id,
    script_filenames=[
        "src/1_sql/1_aux_steroids.sql",
        "src/1_sql/3_onlyGlucose.sql",
    ],
):
    # Run SQL scripts in order
    for script_filename in script_filenames:
        print(f"Executing {script_filename}...")
        with open(script_filename, "r") as script_file:
            script = script_file.read().replace("db_name", project_id)
            job = client.query(script)
            job.result()  # Wait for the query to complete


def create_main_table(client, project_id, destination):
    print(f"Creating main table {destination}...")
    with open("src/1_sql/4_final_dataSelect.sql", "r") as script_file:
        script = script_file.read().replace("db_name", project_id)
        df = client.query(script).to_dataframe()
        df.to_csv(destination, index=False)


def main(args):
    # Load environment variables
    load_dotenv()
    # Get GCP's secrets
    KEYS_FILE = os.getenv("KEYS_FILE")
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = KEYS_FILE
    project_id = os.getenv("PROJECT_ID")
    # Set up BigQuery client using default SDK credentials
    client = bigquery.Client(project=project_id)
    # create the icd9 to 10 map table
    create_icd9_to_10_map(client, project_id)
    # create the aux dataset
    create_aux_dataset(client, project_id)
    # create the aux tables
    create_aux_tables(client, project_id)
    # create the main table
    create_main_table(client, project_id, args.destination)


if __name__ == "__main__":
    # parse the arguments
    parser = ArgumentParser()
    parser.add_argument(
        "-d",
        "--destination",
        default="data/MIMIC.csv",
        help="output csv file",
    )
    args = parser.parse_args()
    main(args)
