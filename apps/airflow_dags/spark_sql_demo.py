import datetime

from airflow import models
from airflow.providers.google.cloud.operators.dataproc import DataprocSubmitSparkSqlJobOperator
from airflow.utils.dates import days_ago

project_id = "itversity-rnd"

default_args = {
    # Tell airflow to start one day ago, so that it runs as soon as you upload it
    "start_date": days_ago(1),
    "project_id": project_id,
    "region": "us-central1"
}

with models.DAG(
    "spark_sql_demo",
    default_args=default_args,
    schedule_interval=datetime.timedelta(days=1)
) as dag:
    run_query = DataprocSubmitSparkSqlJobOperator(
        project_id='itversity-rnd',
        region='us-central1',
        cluster_name='aidataprocdev',
        query='SELECT current_date',
        task_id='run_spark_sql_query',
    )