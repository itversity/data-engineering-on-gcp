# Data Pipeline Orchestration using Google Cloud Composer

## Overview of Google Cloud Composer
Cloud Composer is a fully managed workflow orchestration service built on Open Source Apache Airflow.
* Author or Build Orchestrated Data Pipelines
* Schedule the Data Pipelines as per the requirements
* Monitor the execution of Data Pipelines using UI as well as APIs
* We typically develop Orchestrated Data Pipelines using Python
* Orchestrated Data Pipelines in Airflow are also known as DAGs (Directed Acyclic Graphs)

Here are the benefits of Google Cloud Composer
* Fully Managed Workflow or Data Pipeline Orchestration
* Easy Integration with other GCP Services
* Supports Hybrid and Multi-cloud

You can follow this [page](https://cloud.google.com/composer) to get more details about Google Cloud Composer. As part of this section, we will see how build Orchestrated Spark based Pipelines using GCP Services such as Google BigQuery, GCP Dataproc, etc.

## Create Google Cloud Composer Environment
Let us take care of creating Google Cloud Composer Environment.
* Login to Google Cloud Console
* Search for Cloud Composer and choose relevant service
* Create Environment using "Cloud Composer 2" with SMALL configuration.
* Make sure to review some of the important details about the environment.
  * GCS Bucket that is being used
  * DAGs folder
  * Airflow UI

## Development Process of Airflow DAGs for Cloud Composer
Let us make sure we understand the development process of Airflow DAGs for Cloud Composer.
* We will use our local VS Code based environment for the development of DAGs.
* Once the development is done, we will copy DAGs to GCS.
* We will monitor the DAGs using Airflow UI in Cloud Composer.

## Install required dependencies for development
Let us ensure that we install the required dependencies for local development of Airflow DAGs.
* We will use local development environment for the development.
* We need to install following dependencies to develop Airflow DAGs for GCP Services.

```shell
pip install apache-airflow==2.3.3
pip install apache-airflow-providers-google
```

## Run Airflow Commands using gcloud
Let us understand how to interact with Airflow that is setup using Cloud Composer Environment using CLI.
* We can use `gcloud composer` commands to interact with Airflow on Cloud Composer Environment.
* Before running the commands, make sure to upgrade gcloud using `gcloud components update` command.
* Here is an example command. This command is equivalent to `airflow dags list`.

```shell
gcloud composer environments run --location=us-central1 --project=tidy-fort-361710 aiairflow dags list
```

## Overview of Airflow Architecture
Let us quickly review the [Overview of Airflow Architecture](https://airflow.apache.org/docs/apache-airflow/stable/concepts/overview.html). Airflow is setup using multiple components.
* Scheduler - Used for Scheduling
* Webserver - Used for Managing Airflow DAGs, Variables, Users and other Administrative tasks.
* Worker(s) - Used for executing the tasks that are part of DAGs.

Let us understand how Airflow works.
* We typically develop and deploy DAGs. A DAG is a collection of all the tasks you want to run, organized in a way that reflects their relationships and dependencies.
* DAGs are also popularly known as Orchestrated Pipelines.
* Using Web UI provided by Web Server, we can manage DAG Runs, configure Variables, etc.
* Scheduler will continuously run and see if the DAGs are supposed to run.
* Workers will execute the tasks in the DAGs in orchestrated fashion.

## Run First Airflow DAG in Cloud Composer
Let us understand how to run first Aiflow DAG in Cloud Composer.
* Copy the DAG to GCS to relevant location.
* Wait for some time and review to see if the DAG is reflected in Airflow UI and also see if it run automatically or not.

Here is the command that is used to copy the Airflow DAG (Python Script) to GCS.
```shell
gsutil ls gs://us-central1-aiairflow-206f06a1-bucket/dags
gsutil cp apps/airflow_dags/tutorial_dag.py gs://us-central1-aiairflow-206f06a1-bucket/dags

gsutil ls gs://us-central1-aiairflow-206f06a1-bucket/dags
```

Here is what happens to identify the DAGs.
* All the Python scripts in DAGs folder will be parsed periodically for the DAGs.
* The DAGs will be refreshed as part of the UI.
* One Python program can have multiple DAGs and one DAG might be spawned across multiple Python Scripts.

## Overview of Airflow Dataproc Operators

Let us get an overview of Dataproc Operators. As we have installed `apache-airflow-providers-google`, the provider related to Dataproc Operators also will be installed.

Here are the different ways we can submit Spark Applications on Dataproc.
* Submit Spark SQL or Pyspark or Scala based Spark applications directly.
* Submit Spark SQL or Pyspark or Scala based Spark applications as Dataproc Jobs.
* Submit Spark SQL or Pyspark or Scala based Spark applications as jobs in Dataproc Workflow Templates.

Using Airflow Dataproc Operators we can either submit Spark SQL or Pyspark or Scala based Spark applications as Dataproc Jobs or via Workflow Templates. We will explore both.

## Trigger GCP Dataproc Workflow using Cloud Composer

Let us undestand how to trigger GCP Dataproc Workflow using Cloud Composer.
* Make required changes to the Airflow DAG with relevant Operator to trigger Dataproc Workflow.
  * Project Id
  * Bucket
* Deploy the Airflow DAG to GCS and Run it.

## Using Variables in Airflow DAGs

Let us refactor the code using variables rather than hard coded values for project id, region, etc.
* Create new Python program file and make changes to the code to use values from variables for project id and region.
* Make sure to change the DAG id as it is supposed to be unique.
* Use Airflow UI to define required variables.
* Deploy and Run the DAG.
* Monitor both Airflow DAG and Dataproc Workflow.

## Data Pipeline using Cloud Composer and Dataproc Jobs

Let us deploy Data Pipeline using Cloud Composer to submit the end to end orchestrated pipeline using Spark SQL and Pyspark based applications.
* Review the scripts in GCS.
* Review the code related to the DAG.
* Deploy and Run the DAG.
* Monitor both DAG run as well as Dataproc Jobs.

## Differences between Airflow DAGs and Dataproc Workflows

Here are some of the differences between Airflow DAGs and Dataproc Workflows.
* Dataproc Workflows can be used to orchestrate Dataproc Jobs using Spark, Hadoop, Pig, etc.
* Airflow DAGs have a lot more flexibility. You can create orchestrated pipelines using different services in GCP and even on other Cloud Platforms.
* Airflow is used for both Orchestration as well as Scheduling. It have robust scheduling features.
* Airflow is typically used as Enterprise level Workflow and Scheduling tool. There can be Airflow based Pipelines using Dataproc Jobs or Workflows.

Dataproc Workflows can be considered for quick proof of concepts and production scale pipelines for smaller organizations where they have limited workflows based on larger data sets which are supposed to be processed using Big Data Technologies like Hadoop, Spark, etc. For larger organizations, it is important to have enterprise orchestration tools such as Airflow.
