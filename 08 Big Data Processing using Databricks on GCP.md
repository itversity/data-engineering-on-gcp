# Big Data Processing using Databricks on GCP

## Overview of Databricks on GCP
Let us get an overview of Databricks on Google Cloud Platform.
* Databricks is cloud agnostic Spark based Big Data Processig Platform.
* Databricks is available on all leading cloud platforms.
  * AWS
  * Azure
  * **Google Cloud Platform (GCP)**
* Here are the features of Databricks on GCP.
  * Seamless Integration with GCS for Data Lake Storage.
  * Purpose Built Clusters for different workloads.
  * Pay-as-you-go
  * Scalability including Auto Scalability
  * Easy Integrations with other Google Services such as Big Query, Looker, etc
  * Big Query is used for Data Warehousing while Looker is used for Business Intelligence (Visualizations such as Reports and Dashboards).

## Signing up for Databricks on GCP
Let us see how we can sign up for Databricks Subscription on GCP.
* Login to GCP Console.
* Search for Databricks in global search bar and complete the sign up process.

## Creating Databricks Workspace on GCP

As we have signed up for Databricks Subscription for GCP, it is time for us to create Databricks Workspace. Follow the steps as demonstrated in the lecture to create the Databricks Workspace.

Here are some references to review and also request to change the quota limits.
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
Let us get an overview of Databricks Workflows.
* Data Pipelines are deployed using Workflows in Databricks.
* We create Jobs under Workflows. Each Job is group of tasks.
* Complex Spark Applications needs to be deployed using a Job under Workflows.
* Each Job can have multiple tasks with dependencies between them.
* If series of steps or tasks in the pipeline need to run using Databricks platform with out depending on external applications, then they can be orchestrated using a Job.
* We can pass parameters at each Task Level or Job Level.
* Each Task in the Job can be configured using different clusters based on the run time as well as cluster size requirements for the respective Task.

## Modularize Spark Applications as Multiple Tasks
Let us see how to modularize Spark Applications as Multiple Tasks.
* We will use folders under `retail_db_header`.

The logic will be divided into two SQL based Notebooks.
* File Format Converter - converts CSV to Parquet based on the argument passed.
* Compute Daily Product Revenue
* We will also create additional Notebook, to validate whether Notebooks are working as expected or not.

A dbc archive will be provided under the notebooks repository. One can just export into their platform and review the SQL Notebooks.

## Orchestration using Databricks Workflows
As the required Notebooks are ready, let us go ahead and create Databricks Workflow or Job with multiple tasks. We will create tasks using relevant Notebooks.
* Create a task by name `FileConverterOrders` to convert file format of orders data set.
* Create a task by name `FileConverterOrderItems` to convert file format of order_items data set.
* Create a task by name `ComputeDailyProductRevenue` to compute daily product revenue.
* Add the tasks to convert file format to the workflow without any dependencies.
* Add the task to compute daily product revenue to the workflow. Add both the file format converter tasks as dependencies to this one as dependencies.

## Run and Validate Databricks Workflows
Let us understand different options to run jobs or workflows and also let us see how to run the job or workflow using **Run now**.

Here are the different options to run jobs or workflows.
* Run now
* Run now with parameters
* Using Schedule (supports cron syntax as well)

Let us run the job or workflow and review the details at job or workflow level.

## Troubleshoot Spark Jobs using Spark UI on Databricks
As the Databricks job or workflow is run, let us review the Spark jobs associated with Databricks job tasks using Spark UI.
* Go to the latest run of Databricks job or workflow.
* For each task we can review the details of the respective Notebook.
* We can go to Spark UI and check the respective Spark Job logs as well.
* If the jobs fail, we need to make review driver logs as well as Spark Job level logs.

## Integration of GCS with Databricks on GCP