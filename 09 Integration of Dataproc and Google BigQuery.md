# Integration of Dataproc and BigQuery

## Setup Development Environment using Dataproc
Make sure to use VS Code Remote Development Extension Pack and Setup Development Environment using Dataproc.
* We have already gone through the details in previous section.

## Validate Google BigQuery Integration with Python
Let us validate Google BigQuery Integration with Python.
```python
from google.cloud import bigquery

client = bigquery.Client()
QUERY = (
    'SELECT * FROM `tidy-fort-361710.retail.orders` '
    'LIMIT 10'
)
query_job = client.query(QUERY)
rows = query_job.result()

for row in rows:
    print(row.order_id)
```

## Validate Google BigQuery Integration with Pyspark
Let us go ahead and validate Google BigQuery Integration with Pyspark. We need to make sure Pyspark is launched with appropriate jars of Google BigQuery Spark Connector.
* Here is the command used based on the version of Scala using which Spark is developed.

```shell
pyspark --jars gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.26.0.jar
```

* Here is sample Spark Code to read from BigQuery Table.

```python
project_id = 'tidy-fort-361710'

df = spark. \
    read. \
    format('bigquery'). \
    option('table', f'{project_id}:retail.orders'). \
    load()

df.printSchema()

df.orderBy('order_id').show()
```

## Review Logic to Compute Daily Product Revenue
Let us review the logic to compute daily product revenue. We have already deployed workflow using Spark SQL Commands.
* Jobs to take care of file format converter for `orders` and `order_items`.
* Job to compute daily product revenue and save the results to a folder in GCS.
* We now need to create Pyspark Job to save the daily product revenue to BigQuery Table.

## Create Table in Google BigQuery
Let us go ahead and create Table in Google BigQuery to preserve daily product revenue.
* We can use the `CREATE TABLE` command that is part of the script used to compute daily compute revenue as reference.
```sql
CREATE TABLE IF NOT EXISTS retail.daily_product_revenue (
    order_date STRING,
    order_item_product_id INTEGER,
    order_status STRING,
    product_quantity INTEGER,
    product_revenue DECIMAL
);
```

## Develop Logic to Save Result to BigQuery Table
Now it is time for us to develop the logic to write data in Dataframe to BigQuery Table.
* Create Dataframe using data in GCS files.
* Set GCS bucket as temporary bucket.
* Develop logic to write to Google BigQuery Table.

```python
daily_product_revenue = spark. \
    read. \
    parquet('gs://airetail/retail_gold.db/daily_product_revenue')

spark.conf.set('temporaryGcsBucket', 'airetail')

project_id = 'tidy-fort-361710'

daily_product_revenue. \
    write. \
    mode('overwrite'). \
    format('bigquery'). \
    option('table', f'{project_id}:retail.daily_product_revenue'). \
    save()
```

* Validate by Querying Google BigQuery Table.

Make sure to login and validate by querying table in Google BigQuery.

## Reset Table in Google BigQuery
Let us go ahead and truncate the table in BigQuery, so that we can deploy the Spark Job to load the data into the table.
* We can use `TRUNCATE TABLE retail.daily_product_revenue` to truncate the table.

## Build Dataproc Spark Job with BigQuery Integration

Let us go ahead and create program file with core logic to write data from parquet files into BigQuery Table using Spark. Once the program file is ready we can follow below instructions to validate the application using client mode.

* The application is already made available to you under `apps` folder. Make sure to review the application before running it.
* Export all the relevant variables. Make sure to update values based on your environment.

```shell
export DATA_URI='gs://airetail/retail_gold.db/daily_product_revenue'
export PROJECT_ID='tidy-fort-361710'
export DATASET_NAME='retail'
export GCS_TEMP_BUCKET='airetail'
```

* Run `spark-submit` to submit the job.

```shell
spark-submit \
    --master yarn \
    --name "Daily Product Revenue Loader" \
    --jars gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.26.0.jar \
    app.py
```

Here are the instructions to submit the same Spark Job using cluster mode.
```shell
spark-submit \
    --master yarn \
    --deploy-mode cluster \
    --name "Daily Product Revenue Loader" \
    --jars gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.26.0.jar \
    --conf "spark.yarn.appMasterEnv.DATA_URI=gs://airetail/retail_gold.db/daily_product_revenue" \
    --conf "spark.yarn.appMasterEnv.PROJECT_ID=tidy-fort-361710" \
    --conf "spark.yarn.appMasterEnv.DATASET_NAME=retail" \
    --conf "spark.yarn.appMasterEnv.GCS_TEMP_BUCKET=airetail" \
    app.py
```

## Deploy Spark Application with BigQuery Integration to GCS
Make sure to copy the application to GCS so that we can create the job without any issue using Dataproc.

```
gsutil cp apps/daily_product_revenue_bq/app.py gs://airetail/apps/daily_product_revenue_bq/app.py
```
* One can validate whether the application can be run from GCS or not by submitting the job using `spark-submit`.

```shell
spark-submit \
    --master yarn \
    --deploy-mode cluster \
    --name "Daily Product Revenue Loader" \
    --jars gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.26.0.jar \
	--conf "spark.yarn.appMasterEnv.DATA_URI=gs://airetail/retail_gold.db/daily_product_revenue" \
	--conf "spark.yarn.appMasterEnv.PROJECT_ID=tidy-fort-361710" \
	--conf "spark.yarn.appMasterEnv.DATASET_NAME=retail" \
	--conf "spark.yarn.appMasterEnv.GCS_TEMP_BUCKET=airetail" \
	gs://airetail/apps/daily_product_revenue_bq/app.py
```

## Deploy and Run Dataproc Spark Job
Here are the configurations related to Dataproc Spark Job.
* Job type: **PySpark**
* Main python file: **gs://airetail/apps/daily_product_revenue_bq/app.py**
* Jar files: **gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.26.0.jar**
* Properties

|Key|Value|
|---|---|
|spark.yarn.appMasterEnv.DATA_URI|gs://airetail/retail_gold.db/daily_product_revenue|
|spark.yarn.appMasterEnv.PROJECT_ID|tidy-fort-361710|
|spark.yarn.appMasterEnv.DATASET_NAME|retail|
|spark.yarn.appMasterEnv.GCS_TEMP_BUCKET|airetail|
|spark.submit.deployMode|cluster|
|spark.app.name|Daily Product Revenue Loader|

Let us take care of submitting the application using `gcloud dataproc` command from our local development environment (Mac or Windows PC).

```shell
gcloud dataproc jobs submit \
    pyspark --cluster=aidataprocdev \
    --jars=gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.26.0.jar \
	--properties=spark.app.name="BigQuery Loader - Daily Product Revenue" \
    --properties=spark.submit.deployMode=cluster \
    --properties=spark.yarn.appMasterEnv.DATA_URI=gs://airetail/retail_gold.db/daily_product_revenue \
    --properties=spark.yarn.appMasterEnv.PROJECT_ID=tidy-fort-361710 \
    --properties=spark.yarn.appMasterEnv.DATASET_NAME=retail \
    --properties=spark.yarn.appMasterEnv.GCS_TEMP_BUCKET=airetail \
    gs://airetail/apps/daily_product_revenue_bq/app.py
```

## Spark Data Pipeline using Dataproc Workflow
Let us make sure we create the Dataproc Workflow for the end to end pipeline including Pyspark Application to load daily product revenue data from Parquet Files to BigQuery Table. Here are the details related to end-to-end pipeline.
* Cleanup Spark Metastore Databases and Tables.
* Convert Files from JSON to Parquet for Orders and Order Items.
* Compute Daily Product Revenue and save the output to GCS using Parquet Files.
* Copy Data from GCS into BigQuery Table using Spark BigQuery Connector.

We will be using relevant `gcloud dataproc` commands to create the workflow. Please refer to the Notebook which have all the relevant commands.

## Run and Validate the Dataproc Workflow
As Dataproc Workflow is created, let us instantiate and validate if it run without any issues.
* Make sure to truncate BigQuery Table before running the Workflow.

## Update Job Properties in Dataproc Workflow Template
Let us understand how to fix issues by updating job properties in Dataproc Workflow Template.
* Make sure the issue is troubleshooted.
* Remove the job from Workflow Template.
* Add the job back to Workflow Template by fixing the properties relevant to job.
* Run the template and validate.

Now, the Workflow Template is ready to schedule. You can integrate Workflow Template with your enterprise scheduler either by using Shell scripts or commands, REST APIs as well as SDK. For example, we can use relevant Airflow Operator (Airflow Google Cloud SDK) to run Workflow Templates.