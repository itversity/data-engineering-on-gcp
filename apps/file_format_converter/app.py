import json
import sys
import os
from pyspark.sql import SparkSession


def get_columns(spark, schemas_file, ds_name):
    schema_text = spark.read.text(schemas_file, wholetext=True).first().value
    schemas = json.loads(schema_text)
    column_details = schemas[ds_name]
    columns = [col['column_name'] for col in sorted(column_details, key=lambda col: col['column_position'])]
    return columns


def convert(spark, ds, src_base_dir, bronze_base_dir):
    print(f'Processing {ds} data')
    columns = get_columns(spark, f'{src_base_dir}/schemas.json', ds)
    df = spark. \
        read. \
        csv(f'{src_base_dir}/{ds}', inferSchema=True). \
        toDF(*columns)
    df.write. \
        mode('overwrite'). \
        parquet(f'{bronze_base_dir}/{ds}')


def main():
    args = sys.argv
    ds = args[1]
    src_base_dir = os.environ.get('SRC_BASE_DIR')
    bronze_base_dir = os.environ.get('BRONZE_BASE_DIR')
    schemas_file = f'{src_base_dir}/schemas.json'
    spark = SparkSession. \
        builder. \
        master('yarn'). \
        appName(f'File Format Convert - {ds}'). \
        getOrCreate()
    get_columns(spark, schemas_file, ds)
    convert(spark, ds, src_base_dir, bronze_base_dir)


if __name__ == '__main__':
    main()
