import os
from pyspark.sql import SparkSession

spark = SparkSession. \
    builder. \
    getOrCreate()

data_uri = os.environ.get('DATA_URI')
project_id = os.environ.get('PROJECT_ID')
dateset_name = os.environ.get('DATASET_NAME')
gcs_temp_bucket = os.environ.get('GCS_TEMP_BUCKET')

daily_product_revenue = spark. \
    read. \
    parquet(data_uri)

spark.conf.set('temporaryGcsBucket', gcs_temp_bucket)

daily_product_revenue. \
    write. \
    mode('overwrite'). \
    format('bigquery'). \
    option('table', f'{project_id}:{dateset_name}.daily_product_revenue'). \
    save()