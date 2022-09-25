# Big Data Processing using Databricks on GCP

## Overview of Databricks on GCP

## Signing up for Databricks on GCP

## Creating Databricks Workspace on GCP

* Review Quotas by going to this [page](https://docs.gcp.databricks.com/administration-guide/account-settings-gcp/quotas.html).
* [Page](https://console.cloud.google.com/iam-admin/quotas) to review and change the quota limits.

## Overview of Databricks CLI

As part of this lecture we will understand what is Databricks CLI and also how to configure Databricks CLI.

## Overview of Managing DBFS using Databricks CLI

As part of this lecture we will understand how to manage DBFS using Databricks CLI.
* We can use `databricks fs` to manage files in DBFS.

Here are the common tasks which can be performed using `databricks fs` command.
* Copy files from local file system from client to DBFS and vice versa.
* List files in DBFS usng `databricks fs ls`.
* Delete files in DFBS using `databricks fs rm`. Folders can be deleted recursively by using `--recursive`.

## Copy Data Sets to DBFS using Databricks CLI

Let us copy retail data set to DBFS using Databricks CLI. We will be using `dbfs:/public` as base folder for the datasets.
* Check all the subcommands available under `databricks fs`.
* Delete `dbfs:/public/retail_db`, if exists. 
* Make sure folder `dbfs:/public` exists in DBFS.
* Copy `data/retail_db` recursively to `dbfs:/public/retail_db`.
* Validate whether the `dbfs:/public/retail_db` contains sub folders related to multiple tables and also few sql scripts.

Here are the commands that can be used for above mentioned tasks for the reference.
```shell
databricks fs -h
databricks fs rm dbfs:/public/data/retail_db --recursive
databricks fs mkdirs dbfs:/public/data
databricks fs cp data/retail_db dbfs:/public/data/retail_db --recursive

# Below command can be used to overwrite the retail_db folder, if exists
databricks fs cp data/retail_db dbfs:/public/data/retail_db --recursive --overwrite

databricks fs ls dbfs:/public/data/retail_db # recursive doesn't work
```

## Spark SQL Example using Databricks

Let us go ahead and compute daily product revenue using Spark SQL. We can compute daily product revenue using `orders` and `order_items` data sets.

Here are the steps involved to compute daily product revenue using Spark SQL.
* Create Temporary View by name `orders` pointing to `dbfs:/public/retail_db/orders`.
* Create Temporary View by name `order_items` pointing to `dbfs:/public/retail_db/order_items`.
* Develop Query to compute Daily Product Revenue.
* Make sure output is written back to `dbfs:/public/retail_db/daily_product_revenue` using parquet file format.
* Validate whether the output is saved in DBFS as per the expectations or not.
* The queries will be provided as part of Databricks Notebook.

## Pyspark Example using Databricks

Let us go ahead and compute daily product revenue using Pyspark Data Frame APIs. We can compute daily product revenue using `orders` and `order_items` data sets.

Here are the steps involved to compute daily product revenue using Pyspark Data Frame APIs.
* Create Data Frame by name `orders` pointing to `dbfs:/public/retail_db/orders`.
* Create Data Frame by name `order_items` pointing to `dbfs:/public/retail_db/order_items`.
* Develop Query to compute Daily Product Revenue.
* Make sure output is written back to `dbfs:/public/retail_db/daily_product_revenue` using parquet file format.
* As we will be using same location again and again, we need to make sure the data is written to target location using overwrite mode.
* Validate whether the output is saved in DBFS as per the expectations or not.
* The queries will be provided as part of Databricks Notebook.

## Overview of Databricks Workflows

## Modularize Spark Applications as Multiple Jobs
Let us see how to modularize Spark Applications as Multiple Jobs.
* We will use folders under `retail_db_header`.

The logic will be divided into two SQL based Notebooks.
* File Format Converter - converts JSON to Parquet based on the argument passed.
* Compute Daily Product Revenue

A dbc archive will be provided under the notebooks repository. One can just export into their platform and review the SQL Notebooks.

## Job Orchestration using Databricks Workflows

## Troubleshooting Spark Jobs using Spark UI on Databricks

## Integration of GCS with Databricks on GCP