import datetime

from airflow import models
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocInstantiateWorkflowTemplateOperator,
)
from airflow.utils.dates import days_ago

# Make sure to update these values as per your environment
project_id = "tidy-fort-361710"
region = "us-central1"

default_args = {
    # Tell airflow to start one day ago, so that it runs as soon as you upload it
    "project_id": project_id,
    "region": region,
    "start_date": days_ago(1)
}

with models.DAG(
    "daily_product_revenue_wf_dag",
    default_args=default_args,
    # The interval with which to schedule the DAG
    schedule_interval=datetime.timedelta(days=1), 
) as dag:

    start_template_job = DataprocInstantiateWorkflowTemplateOperator(
        # The task id of your Airflow job
        task_id="daily_product_revenue_wf",
        # The template id of your Dataproc workflow
        template_id="wf-daily-product-revenue-bq"
    )