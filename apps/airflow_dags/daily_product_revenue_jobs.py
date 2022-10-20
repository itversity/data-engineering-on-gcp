import datetime

from airflow import models
from airflow.models import Variable
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocSubmitSparkSqlJobOperator,
    DataprocSubmitPySparkJobOperator
)
from airflow.utils.dates import days_ago

project_id = Variable.get('project_id')
region = Variable.get('region')
bucket_name = Variable.get('bucket_name')
cluster_name = Variable.get('cluster_name')

default_args = {
    # Tell airflow to start one day ago, so that it runs as soon as you upload it
    "project_id": project_id,
    "region": region,
    "cluster_name": cluster_name,
    "start_date": days_ago(1)
}

with models.DAG(
    "daily_product_revenue_jobs_dag",
    default_args=default_args,
    schedule_interval=datetime.timedelta(days=1)
) as dag:
    task_cleanup = DataprocSubmitSparkSqlJobOperator(
        task_id='run_cleanup',
        query_uri=f'gs://{bucket_name}/scripts/daily_product_revenue/cleanup.sql',
    )

    task_convert_orders = DataprocSubmitSparkSqlJobOperator(
        task_id='run_convert_orders',
        query_uri=f'gs://{bucket_name}/scripts/daily_product_revenue/file_format_converter.sql',
        variables={
            'bucket_name': f'gs://{bucket_name}',
            'table_name': 'orders'
        },
    )

    task_convert_order_items = DataprocSubmitSparkSqlJobOperator(
        task_id='run_convert_order_items',
        query_uri=f'gs://{bucket_name}/scripts/daily_product_revenue/file_format_converter.sql',
        variables={
            'bucket_name': f'gs://{bucket_name}',
            'table_name': 'order_items'
        },
    )

    task_compute_daily_product_revenue = DataprocSubmitSparkSqlJobOperator(
        task_id='run_compute_daily_product_revenue',
        query_uri=f'gs://{bucket_name}/scripts/daily_product_revenue/compute_daily_product_revenue.sql',
        variables={
            'bucket_name': f'gs://{bucket_name}'
        },
    )

    task_load_dpr_bq = DataprocSubmitPySparkJobOperator(
        task_id='run_load_dpr_bq',
        main=f'gs://{bucket_name}/apps/daily_product_revenue_bq/app.py',
        dataproc_jars=['gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.26.0.jar'],
        dataproc_properties={
            'spark.app.name': 'BigQuery Loader - Daily Product Revenue',
            'spark.submit.deployMode': 'cluster',
            'spark.yarn.appMasterEnv.DATA_URI': f'gs://{bucket_name}/retail_gold.db/daily_product_revenue',
            'spark.yarn.appMasterEnv.PROJECT_ID': project_id,
            'spark.yarn.appMasterEnv.DATASET_NAME': 'retail',
            'spark.yarn.appMasterEnv.GCS_TEMP_BUCKET': bucket_name
        },
    )
    
    task_cleanup >> task_convert_orders
    task_cleanup >> task_convert_order_items

    task_convert_orders >> task_compute_daily_product_revenue
    task_convert_order_items >> task_compute_daily_product_revenue

    task_compute_daily_product_revenue >> task_load_dpr_bq
    