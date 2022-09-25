# Data Processing using Google Cloud Functions

## Overview of Google Cloud Functions

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
* Schema: `landing/retail_db/schema.json`
* Target: `bronze/retail_db/orders`
* Target File Format: `parquet`

Here is the design for the file format conversion.
* The application should take table name as argument.
* It has to read the schema from `schema.json` and need to be applied on `CSV` data while creating Pandas Data Frame.
* The Data Frame should be written to target using target file format.
* Source Bucket, Target Bucket as well as base folders should be passed as environment variables.

```python
import pandas as pd
columns = ['order_id', 'order_date', 'order_customer_id', 'order_status']
df = pd.read_csv('gs://airetail/retail_db/orders/part-00000', names=columns)
df.to_parquet('gs://airetail/retail_db_parquet/orders/part-00000.snappy.parquet')
```

## Deploy Inline Application as Google Cloud Function

## Run Inline Application as Google Cloud Function

## Deploy Zipped Application in GCS as Google Cloud Function

## Run Zipped Application in GCS as Google Cloud Function

## Validate File Format Converter Google Cloud Function