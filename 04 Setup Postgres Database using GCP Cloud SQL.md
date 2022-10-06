# Setup Postgres Database using Cloud SQL

## Overview of Cloud SQL
Cloud SQL is GCP Fully Managed Relational Database Service. Let us get an overview of Cloud SQL.
* We can setup MySQL, Postgres or SQL Server using Cloud SQL.
* Relational Databases are typically used to develop web or mobile applications.
* Relational Databases are one of the sources for Data Lakes or Data Warehouses.

Here are some of the key benefits with respect to Cloud SQL
* Quick and Easy Setup
* Fully Managed by Google Cloud
* Reliable with regular backups and high availability
* Easy migrations using services like Data Migration Service

Review [Official Documentation](https://cloud.google.com/sql) for more details.

## Setup Postgres Database using Cloud SQL
Let us go ahead and setup Postgres Database using Cloud SQL.
* Login into the Google Cloud Console.
* Search for Cloud SQL.
* Use the wizard to setup Postgres Database using Cloud SQL.
* Choose Development, Single Zone with Postgres 14. Make sure to name the instance as retail.
* Expand Configuration Options and make sure to enable Public IP.

## Configure Network for Cloud SQL Postgres Database
Let us go ahead and configure network for Cloud SQL Postgres Database, so that we can connect from our local development environments.
* We need to get the IP of our PC and add it to the CIDR.
* If telnet is setup, we can use telnet to validate the network connectivity.

## Connect to Postgres Database using Developer Tools
Make sure to setup Postgres on your local environment, so that you get all the tools such as pgAdmin, psql, etc.
* You can use pgAdmin or psql to connect to Postgres Database provisioned using GCP Cloud SQL.
* Make sure to keep the credentials handy and then use the following command as reference to connect to the database. Replace <host_ip>, with actual ip address of the Postgres Database Server.

```shell
psql -h <host_ip> -U postgres -W
```

## Setup Database in GCP Cloud SQL Postgres Database Server
```sql
CREATE DATABASE itversity_retail_db;
CREATE USER itversity_retail_user WITH ENCRYPTED PASSWORD 'itversity';
GRANT ALL ON DATABASE itversity_retail_db TO itversity_retail_user;
```

## Setup Tables in GCP Cloud SQL Postgres Database
Let us go ahead and setup retail db tables and also populate data in Postgres Database provisioned using Cloud SQL.
* The scripts are provided under `data/retail_db` folder with in this GitHub repository.
* Connect to the newly created Postgres Database using `psql`. Here is the command for your reference.

```shell
psql -h <host_ip> -d itversity_retail_db -U itversity_retail_user -W
```

* Run the below commands to create tables and also populate data in the tables.

```sql
\i data/retail_db/create_db_tables_pg.sql 
\i data/retail_db/load_db_tables_pg.sql
```

## Validate Data in GCP Cloud SQL Postgres Database Tables
Here are the SQL Queries you can use to validate data in the tables. You can run these using `psql` or tools such as pgAdmin.

```sql
\d -- List tables

SELECT * FROM departments;
SELECT count(*) FROM departments;

SELECT * FROM orders LIMIT 10;
SELECT count(*) FROM orders;

SELECT * FROM order_items LIMIT 10;
SELECT count(*) FROM order_items;

SELECT count(*) FROM categories;
SELECT count(*) FROM products;
SELECT count(*) FROM customers;
```

## Integration of GCP Cloud SQL Postgres with Python
Let us also see how we can get started with Python based applications using Cloud SQL Postgres.
* We need to setup `psycopg2-binary` using `pip`. You can use `pip install psycopg2-binary` to install Postgres Python Connector Library in the virtual environment of the project.
* We can then create connection object.
* Using connection object, we can create cursor object by passing relevant query to it.
* We can process the data using cursor object.
* We can perform `SELECT`, `INSERT`, `UPDATE`, `DELETE`, etc using this approach.

```python
import psycopg2
conn = psycopg2.connect(
    host='34.86.31.197',
    database='itversity_retail_db',
    user='itversity_retail_user',
    password='itversity',
)

cur = conn.cursor()
cur.execute('SELECT * FROM orders LIMIT 10')
cur.fetchall()
```

## Integration of GCP Cloud SQL Postgres with Pandas
Pandas is a powerful Python Data Library which is used to process as well as analyze the data. It have robust APIs to work with databases.

Here are the steps involved to use Pandas to work with databases like Postgres.
* We need to make sure `pandas`, `psycopg2-binary` as well as `sqlalchemy` installed using `pip`.
* Pandas uses `sqlalchemy` to interact with database tables based on the connection url.
* `sqlalchemy` is the most popular ORM to hide the complexity of connecting to the databases using libraries such as Pandas.
* Here are the examples using Pandas. We first read the data from the files, process it and then write to Postgres Database using Pandas. We will also read the data written to Postgres Database Table using Pandas for the validation.

```python
import pandas as pd
columns = ['order_id', 'order_date', 'order_customer_id', 'order_status']
orders = pd.read_csv('data/retail_db/orders/part-00000', names=columns)
daily_status_count = orders. \
    groupby(['order_date', 'order_status'])['order_id']. \
    agg(order_count='count'). \
    reset_index()

help(daily_status_count.to_sql)

daily_status_count.to_sql(
    'daily_status_count',
    'postgresql://itversity_retail_user:itversity@34.86.31.197:5432/itversity_retail_db',
    if_exists='replace',
    index=False
)

help(pd.read_sql)

df = pd.read_sql(
    'SELECT * FROM daily_status_count',
    'postgresql://itversity_retail_user:itversity@34.86.31.197:5432/itversity_retail_db'
)
```

## Create Secret for Postgres using GCP Secret Manager
Let us go ahead and create Secret for Postgres using Secret Manager.

## Access Secret Details using Google Cloud SDK
Let us see how to access secret details using Google Cloud Python SDK.

* Follow [this page](https://cloud.google.com/secret-manager/docs/configuring-secret-manager) to configure access to GCP Secret Manager.
* Install `google-cloud-secret-manager`

Here is the process involved to get secret details as part of the applications.
* Create Secret Manager Client Object
* Get Secret Details
* Use Secret Details (to connect to Databases)


```python
import json
from google.cloud import secretmanager
client = secretmanager.SecretManagerServiceClient()

project_id = 'itversity-rnd'
secret_id = 'retailsecret'
version_id = 1
name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"

response = client.access_secret_version(request={"name": name})

payload = json.loads(response.payload.data.decode('utf-8'))
password = payload['password']
```

Instead of hardcoding password, we will be able to get it from secret to connect to the database.

```python
import pandas as pd
df = pd.read_sql(
    'SELECT * FROM daily_status_count',
    f'postgresql://itversity_retail_user:{password}@34.86.31.197:5432/itversity_retail_db'
)
df
```

## Conclusion to Setup Postgres Database using GCP Cloud SQL
As we have gone through details about setting up Postgres Database Server using GCP Cloud SQL, let us go ahead and stop or terminate the Postgres Database Server.
* Stop - Retains Databases and Tables
* Terminate - Every thing will be lost