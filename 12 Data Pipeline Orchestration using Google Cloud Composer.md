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
Let us ensure that we develop the required dependencies for local development of Airflow DAGs.
* We will use local development environment for the development.
* We need to install following dependencies to develop Airflow DAGs for GCP Services.

```shell
pip install apache-airflow
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

## Overview of Dataproc Operators