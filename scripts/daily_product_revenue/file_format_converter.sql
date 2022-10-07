CREATE DATABASE IF NOT EXISTS retail_bronze_db 
LOCATION '${bucket_name}/retail_bronze.db';

USE retail_bronze_db;

CREATE OR REPLACE TEMPORARY VIEW ${table_name}_v 
USING JSON
OPTIONS (
    path='${bucket_name}/retail_db_json/${table_name}'
);

CREATE TABLE IF NOT EXISTS ${table_name}
USING PARQUET
SELECT * FROM ${table_name}_v