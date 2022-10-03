# Data Processing using Google Cloud Functions

## Overview of Google Cloud Functions
Google Cloud Functions are nothing but serverless functions provided as part of Google Cloud Platform.
* Simplified developer experience and increased developer velocity
* Pay only for what you use
* Avoid lock-in with open technology
You can follow this [page](https://cloud.google.com/functions) to get more details about Google Cloud Functions.

## Create First Google Cloud Function using Python

Here are the instructions to create first google cloud function using Python.
* Search for Cloud Function
* Follow the steps as demonstrated to create first Google Cloud Function
* Name: `file_format_converter`
* Language: `python3.9`
* Type: `Cloud Storage` (Default is HTTP)
* Review Default Memory and Timeout Settings

## Run and Validate Google Cloud Function

Here are the instructions to run and validate Google Cloud Function.
* Go to Testing and add this JSON.

```json
{
    "name": "testing.csv"
}
```

## Review File Format Converter Logic using Pandas

> TBD: Need to make the logic dynamic. 
* Source: `landing/retail_db/orders`
* Source File Format: `CSV`
* Schema: `landing/retail_db/schemas.json`
* Target: `bronze/retail_db/orders`
* Target File Format: `parquet`

Here is the design for the file format conversion.
* The application should take table name as argument.
* It has to read the schema from `schemas.json` and need to be applied on `CSV` data while creating Pandas Data Frame.
* The Data Frame should be written to target using target file format.
* Source Bucket, Target Bucket as well as base folders should be passed as environment variables.

```python
import json
import os
import pandas as pd

def get_columns(input_base_dir, ds_name):
    schemas = json.load(open(f'{input_base_dir}/schemas.json'))
    columns = list(map(lambda td: td['column_name'], schemas[ds_name]))
    return columns


input_base_dir = os.environ.get('INPUT_BASE_DIR')
output_base_dir = os.environ.get('OUTPUT_BASE_DIR')
ds_name = 'orders'
columns = get_columns(input_base_dir, ds_name)
print(columns)
for file in os.listdir(f'{input_base_dir}/{ds_name}'):
    print(file)
    df = pd.read_csv(f'{input_base_dir}/{ds_name}/{file}', names=columns)
    os.makedirs(f'{output_base_dir}/{ds_name}', exist_ok=True)
    df.to_parquet(f'{output_base_dir}/{ds_name}/{file}.snappy.parquet')
```

## Deploy Inline Application as Google Cloud Function
As we have reviewed the core logic, let us make sure to deploy file format converted as Google Cloud Function.
* Create Function with relevant run time (Python 3.9).
* Update `requirements.txt` with all the required dependencies.
* Update the program file with the logic to convert the file format.
* Review the configuration and make sure memory is upgraded to 1 GB (from 256 MB)
* Update Environment Variables for bucket names as well as base folder names.

## Run Inline Application as Google Cloud Function
As File Format Converter as deployed as Cloud Function, let us go through the details of running it. We will also validate to confirm if the Cloud Function is working as expected or not.
* Run the Cloud Function by passing Table Name as run time argument.
* Review the logs to confirm, the Cloud Function is executed with out any errors.
* Review the files in GCS in the target location.
* Use Pandas `read_parquet` to see if the data in the converted files can be read into Pandas Data Frame.

## Setup Project for Google Cloud Function
Let us go ahead and setup project for Google Cloud Function using VS Code.
* Create new project.
* Create Python Virtual Environment using Python 3.9
* Add dependencies for local develement to `requirements_dev.txt`
* Add Driver Program for Google Cloud Function.
## Build and Deploy Application in GCS as Google Cloud Function

## Run Deployed Application in GCS as Google Cloud Function
