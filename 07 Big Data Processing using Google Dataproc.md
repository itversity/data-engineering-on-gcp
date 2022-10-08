# Big Data Processing using Google Dataproc

## Overview of GCP Dataproc
Let us get an overview of GCP Dataproc. Dataproc is nothing but fully managed Big Data Cluster by Google Cloud Platform.

Here are the advantages of using GCP Dataproc (Why GCP Dataproc?).
* Low cost
* Super fast (setup)
* Integrated
* Fully Managed
* Simple and familiar

Here are the some of the key features of GCP Dataproc.
* Dataproc Clusters are typically setup using Big Data Technologies such as Hadoop, Hive, Spark, etc.
* Dataproc supports both Single Node as well as Multi Node Clusters.
* Dataproc also supports Jobs and Workflows.
* Dataproc Jobs can be configured using Pig, Hive, Spark SQL, Pyspark, etc.
* Dataproc Workflows can be used to orchestrate multiple Dataproc Jobs.
* Dataproc is well integrated with other GCP Services such as GCS, Big Query, etc.

## Getting Started with GCP Dataproc
Let us understand how to get started with GCP Dataproc. As part of this lecture we will review details related to GCP Dataproc using GCP Web UI.
* Go to GCP Web UI and enable Dataproc in relevant project.
* Here are different types of clusters we can setup using GCP Dataproc.
  * Single Node or Multi-Node Clusters typically for development and testing of the Hadoop and Spark Applications.
  * Large Scale Multi-Node Clusters for Production Environment.
  * All key components such as Hadoop, Hive, Spark, Kafka, etc are available out of the box.
  * We can also add optional components such as Jupyter Notebook, Jupyter Lab, Zeppelin and many more.
  * Dataproc also provides jobs and workflows which can be used to deploy applications built using Hadoop, Hive, Spark, etc.
* As part of this section or module, we will go through all the important features of Dataproc using Single Node Dataproc Cluster.

## Setup Single Node Dataproc Cluster for Development
Let us go ahead and setup Single Node Dataproc Cluster for Development.
* Make sure to review [Dataproc Image Version Lists](https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-version-clusters).
* Make sure to create cluster using following configurations so that development environment can be setup.
  * Cluster Name: **aidataprocdev**
  * Location: Based on your preference
  * Cluster type: **Single Node**
  * Components: Enable component gateway (so that we can access Web Interfaces such as Spark UI)
  * Optional components: Select Jupyterlab

## Configure Network Connectivity to Dataproc Cluster
Let us go ahead and configure Network Connectivity to Dataproc Cluster. We typically connect to the Master Node of Dataproc Cluster.
* Make sure Dataproc Cluster is setup.
* Go to the VM associated with the Master Node of the Dataproc Cluster.
* Go to the Network Configuration and create static ip in the same region as the target Dataproc Cluster.
* Make sure to associate the Master Node of the Dataproc Cluster with static public ip.
* Run gcloud command on personal Mac or PC to update the private key to connect to virtual machine associated with Master Node of the cluster.
* Exit and Validate using SSH to see if connection to the Master Node of the Dataproc Cluster is working as expected or not.

## Remote Development using VS Code on Dataproc
Let us go through the details about setting up remote development using VS Code on Dataproc.
* Make sure Dataproc Cluster is up and running and static ip is configured and validated.
* Make sure to setup VS Code along with Remote Development Extension Pack.
* Configure Remote Connection using VS Code.
* Setup Workspace and clone this repository. Make sure to review the workspace once repository is setup.

## Manage Files in Dataproc using HDFS Commands
Let us understand how to manage files in Dataproc using HDFS Commands.
* Quick recap of HDFS Commands to manage files.
* Review files in GCS using `gsutil`.
* Review local data sets setup using GitHub repository.
* Copy retail_db data set to HDFS from local file system.
* Copy retail_db data set to HDFS from GCS.

```shell
hdfs dfs -ls /user/`whoami`
ls -ltr ~/data-engineering-on-gcp/data

hdfs dfs -mkdir -p /public
hdfs dfs -put ~/data-engineering-on-gcp/data/retail_db /public
hdfs dfs -ls -R /public/retail_db
hdfs dfs -rm -R -skipTrash /public/retail_db

gsutil list gs://airetail/retail_db
hdfs dfs -cp gs://airetail/retail_db /public
hdfs dfs -ls -R /public/retail_db
```

## Validate Spark CLIs in Dataproc Cluster
Let us go ahead and validate Spark CLIs in Dataproc Cluster.
* We will launch Pyspark CLI and run code to compute daily product revenue.
* We will launch Spark Shell with Scala and run code to compute daily product revenue.
* We will launch Spark SQL and run query to compute daily product revenue.

```python
# Launch Pyspark CLI using pyspark command
orders = spark. \
    read. \
    csv(
        '/public/retail_db/orders',
        schema='order_id INT, order_date DATE, order_customer_id INT, order_status STRING'
    )

order_items = spark. \
    read. \
    csv(
        '/public/retail_db/order_items',
        schema='''
            order_item_id INT, order_item_order_id INT, order_item_product_id INT, 
            order_item_quantity INT, order_item_subtotal FLOAT, order_item_product_price FLOAT
        '''
    )

from pyspark.sql.functions import sum, round, col

daily_product_revenue = orders. \
    filter('''order_status IN ('COMPLETE', 'CLOSED')'''). \
    join(order_items, orders['order_id'] == order_items['order_item_order_id']). \
    groupBy('order_date', 'order_item_product_id'). \
    agg(round(sum('order_item_subtotal'), 2).alias('revenue'))

daily_product_revenue.printSchema()
daily_product_revenue. \
    orderBy('order_date', col('revenue').desc()). \
    show()
```

```scala
val orders = spark.
    read.
    schema("order_id INT, order_date DATE, order_customer_id INT, order_status STRING").
    csv(
        "/public/retail_db/orders"
    )

val order_items = spark.
    read.
    schema("""
            order_item_id INT, order_item_order_id INT, order_item_product_id INT, 
            order_item_quantity INT, order_item_subtotal FLOAT, order_item_product_price FLOAT
    """).
    csv(
        "/public/retail_db/order_items"
    )

import org.apache.spark.sql.functions.{sum, round, col}

val daily_product_revenue = orders.
    filter("order_status IN ('COMPLETE', 'CLOSED')").
    join(order_items, orders("order_id") === order_items("order_item_order_id")).
    groupBy("order_date", "order_item_product_id").
    agg(round(sum($"order_item_subtotal"), 2).alias("revenue"))

daily_product_revenue.printSchema
daily_product_revenue.
    orderBy($"order_date", $"revenue".desc).
    show()
```

```sql
CREATE OR REPLACE TEMPORARY VIEW orders (
    order_id INT,
    order_date DATE,
    order_customer_id INT,
    order_status STRING
) USING CSV
OPTIONS (
    path='/public/retail_db/orders'
);

CREATE OR REPLACE TEMPORARY VIEW order_items (
    order_item_id INT,
    order_item_order_id INT,
    order_item_product_id INT,
    order_item_quantity INT,
    order_item_subtotal FLOAT,
    order_item_product_price FLOAT
) USING CSV
OPTIONS (
    path='/public/retail_db/order_items'
);

SELECT order_date,
    order_item_product_id,
    round(sum(order_item_subtotal), 2) AS revenue
FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_item_order_id
WHERE order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2
ORDER BY 1, 3 DESC
LIMIT 10;
```

## Overview of GCP Dataproc Jobs and Workflows
Let us get an overview of Dataproc Jobs and Workflows.
* Dataproc Jobs are used to deploy applications developed using Hadoop, Hive, Spark SQL, Pyspark, etc.
* Workflows are nothing but orchestration of multiple jobs.
* Once all the relevant jobs are created, one can define workflow using the jobs.
* We can define dependencies between the Jobs with in Workflow, so that the jobs are run in a controlled manner.
* Here are the typical steps involved with respect to creating Dataproc Jobs and Workflows.
  * Modularize your application in manageable components.
  * Create Jobs using Hive or Spark SQL or Pyspark or Hadoop, based on the requirements and availability of the modules.
  * Create Workflow Template using Jobs based on the design.

## Getting Started with Dataproc Jobs using Spark SQL
Let us see how to get started with Dataproc Jobs using Spark SQL.
* Go to the Job Wizard
* Create Job of type Spark SQL
* Choose Command and enter the following command.

```
INSERT OVERWRITE DIRECTORY 'gs://airetail/retail_db_json/daily_status_count'
USING JSON
SELECT order_date, order_status, count(*)
FROM JSON.`gs://airetail/retail_db_json/orders`
GROUP BY 1, 2
ORDER BY 1, 3 DESC
```

## Modularize Dataproc Applications as Multiple Jobs
As part of this lecture we will modularize Dataproc Applications as Multiple Jobs using Spark SQL.
* Convert `orders` and `order_items` to **Parquet File Format**. We will have
* Compute Daily Product Revenue and save the result to Google Cloud Storage.

Refer to respective scripts under scripts folder in our Git Repository. Make sure to copy the scripts into GCS and run directly using `spark-sql` on Dataproc Cluster for unit testing.

Here are the commands used to validate local scripts using `spark-sql`.

```shell
spark-sql -f scripts/daily_product_revenue/cleanup.sql

spark-sql -f scripts/daily_product_revenue/file_format_converter.sql \
    -d bucket_name=gs://airetail \
    -d table_name=orders

spark-sql -f scripts/daily_product_revenue/file_format_converter.sql \
    -d bucket_name=gs://airetail \
    -d table_name=order_items

spark-sql -f scripts/daily_product_revenue/compute_daily_product_revenue.sql \
    -d bucket_name=gs://airetail
```

Here are the commands used to deploy the scripts to GCS and then validate using `spark-sql`.

```shell
gsutil cp -r scripts/daily_product_revenue/ gs://airetail/scripts/daily_product_revenue

spark-sql -f gs://airetail/scripts/daily_product_revenue/cleanup.sql

spark-sql -f gs://airetail/scripts/daily_product_revenue/file_format_converter.sql \
    -d bucket_name=gs://airetail \
    -d table_name=orders

spark-sql -f gs://airetail/scripts/daily_product_revenue/file_format_converter.sql \
    -d bucket_name=gs://airetail \
    -d table_name=order_items

spark-sql -f gs://airetail/scripts/daily_product_revenue/compute_daily_product_revenue.sql \
    -d bucket_name=gs://airetail
```

You can review the Notebook for gcloud commands to submit Dataproc Jobs with Spark SQL Scripts.

## Job Orchestration using Dataproc Workflows
Let us go ahead and create Workflow Template with 4 jobs as per design. We will take care of creating Workflow Template using subcommands under `gcloud dataproc workflow-templates`.
* One job to cleanup the databases.
* One job to process `orders` data set and convert into **Parquet** format in a metastore table.
* One job to process `order_items` data set and convert into **Parquet** format in a metastore table.
* One job to compute daily product revenue and store the result in a metastore table.
* The locations for all the 3 tables are based on GCS.

You can review the Jupyter Notebook for the commands related to creating workflow template and running it.

## Run and Validate Dataproc Workflows
Let us make sure to run and validate Dataproc Workflows to understand the overall process of unit testing of the ELT Data Pipelines built using Dataproc Workflows.

Please refer to the relevant Notebooks. We have also covered about how to manage workflow runs using relevant `gcloud dataproc` commands.

## Access Spark UI of GCP Dataproc
Let us also understand how to access Spark UI of GCP Dataproc to troubleshoot issues related to Spark Jobs.