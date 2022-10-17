# Data Warehouse using Google BigQuery

## Overview of Google BigQuery

Google BigQuery is a Cloudbased Data Warehouse. It is not only serverless, but also cost-effective as well as multi-cloud.
* Cost-effective
* Serverless
* Multicloud

Here are the benefits of Google BigQuery.
* Gain insights with real-time and predictive analytics
* Access data and share insights with ease
* Protect your data and operate with trust

Here are the key features of Google BigQuery.
* ML and predictive modeling with BigQuery ML.
* Multicloud data analysis with BigQuery Omni.
* Interactive data analysis with BigQuery BI Engine.
* Geospatial analysis with BigQuery GIS.

You can follow this [page](https://cloud.google.com/bigquery) to get more details about Google BigQuery. As part of this course, we will see how to get started from the perspective of Interactive data analysis with BigQuery BI Engine as it is closest to the Data Engineering. We will also look into key integrations such as Python, Pandas, and Spark using Dataproc/Databricks.

## CRUD Operations using Google BigQuery
Let us quickly review CRUD Operations using Google BigQuery. We can perform all standard CRUD Operations on Google BigQuery Tables.
* INSERT
* UPDATE
* DELETE
* MERGE (also known as UPSERT)

## Create Dataset and Tables in Google BigQuery
Let us go ahead and see how we can create Dataset and an empty table using Google BigQuery.
* Once we login into BigQuery UI, we can create data set under the project. Let us create data set by name **retail**.
* Make sure to choose **Empty table** under **Create table from**.
* Make sure to choose appropriate project id and data set (**retail**).
* Specify the table name as `orders`.
* Enter one column at a time using wizard. You can use the below details as reference.
```
order_id:INTEGER,
order_date:TIMESTAMP,
order_customer_id: INTEGER,
order_status:STRING
```

You can also create table using BigQuery Editor in Google Cloud Console.

```sql
CREATE TABLE tidy-fort-361710.retail.orders (
  order_id INTEGER,
  order_date DATE,
  order_cusotmer_id INTEGER,
  order_status STRING
);
```


## Exercise to Create Additional Tables in Google BigQuery Dataset
Let us go ahead and Create Empty tables for `order_items` and `products` in the `retail` dataset.

Here are the schema details for `order_items`.

```
order_item_id:INTEGER
order_item_order_id:INTEGER
order_item_product_id:INTEGER
order_item_quantity:INTEGER
order_item_subtotal:FLOAT
order_item_product_price:FLOAT
```

Here are the schema details for `products`.

```
product_id:INTEGER
product_cateogry_id:INTEGER
product_name:STRING
product_description:STRING
product_price:FLOAT
product_image:STRING
```

## Load Data into an Empty Table in Google BigQuery
Here is the Python based approach to load data from files in GCS into Google BigQuery Table.
* We need to make sure we instantiate the client.
* Create Job Config using Schema of the table that needs to be populated.
* Use `client.load_table_from_uri` to populate the table from the file under URI using the job config.

You can go through the notebook and make required changes to see if it works as expected or not. You can also validate by running queries against the table using Google BigQuery UI.

## Exercise to Load Data into Tables in Google BigQuery
As we have gone through the details about loading orders data into table in Google BigQuery, take it as an exercise and load data into `order_items` as well as `products`.
* You should have been created these empty tables as part of the previous exercise.

## Cleanup of Tables in Google BigQuery
Let us go ahead and drop the tables in Google BigQuery so that we can create them again.

## Create Tables using GCS Files in Google BigQuery
Let us go ahead and create table for `orders` using Web UI of Google BigQuery. The table will be created using GCS Files.
* After choosing Cloud Storage as source, we can specify column names like this as our data doesn't have header. We need to make sure the data type for `order_date` is defined as `TIMESTAMP`.

```
order_id:INTEGER,
order_date:TIMESTAMP,
order_customer_id: INTEGER,
order_status:STRING
```

You can also use `CREATE EXTERNAL TABLE` command to create table using location in GCS. Here is the [link](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language#create_external_table_statement) for the syntax to create external tables in Google BigQuery.

```sql
CREATE EXTERNAL TABLE retail.orders (
    order_id INTEGER,
    order_date TIMESTAMP,
    order_customer_id INTEGER,
    order_status STRING
) OPTIONS (
    format = 'CSV',
    uris = ['gs://airetail/retail_db/orders/*']
);
```

## Exercise to Create Tables using GCS Files in Google BigQuery
Let us go ahead and Create tables for `order_items` and `products` in the `retail` dataset. This time we will be creating tables pointing to GCS Files.

Here are the schema details for `order_items`.

```
order_item_id:INTEGER
order_item_order_id:INTEGER
order_item_product_id:INTEGER
order_item_quantity:INTEGER
order_item_subtotal:FLOAT
order_item_product_price:FLOAT
```

Here are the schema details for `products`.

```
product_id:INTEGER
product_cateogry_id:INTEGER
product_name:STRING
product_description:STRING
product_price:FLOAT
product_image:STRING
```

## SQL Capabilities of Google BigQuery
Here are some of the SQL Capabilities of Google BigQuery.
* All Standard SQL Features.
  * Robust set of pre-defined functions
  * Filtering of the data
  * Joins (Inner as well as Outer)
  * Standard Aggregations
  * Cumulative Aggregations
  * Ranking as well as Window Functions
* Ability to process JSON Data. 

## Compute Daily Product Revenue using Google BigQuery
Here is the query to compute daily product revenue using Google BigQuery. The query covers most of the basic abilities of SQL using Google BigQuery such as Filtering, Joins, Aggregations, etc.

```sql
SELECT o.order_date,
    oi.order_item_product_id,
    round(sum(oi.order_item_subtotal), 2) AS revenue
FROM retail.orders AS o
    JOIN retail.order_items AS oi
      ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2
ORDER BY 1, 3 DESC
```

## Cumulative Aggregations and Ranking using Google BigQuery
Google BigQuery also supports cumulative aggreations and ranking.
* Cumulative Aggregations using daily revenue

```sql
WITH daily_revenue AS (
    SELECT o.order_date,
        round(sum(oi.order_item_subtotal), 2) AS revenue
    FROM retail.orders AS o
        JOIN retail.order_items AS oi
        ON o.order_id = oi.order_item_order_id
    WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    GROUP BY 1
) SELECT format_date('%Y%m', order_date) AS order_month,
    order_date,
    revenue,
    round(sum(revenue) OVER (
        PARTITION BY format_date('%Y%m', order_date)
        ORDER BY order_date
    ), 2) AS revenue_cum
FROM daily_revenue
ORDER BY 2;
```

* Top 3 Monthly Products by revenue

```sql
WITH daily_product_revenue AS (
    SELECT o.order_date,
        oi.order_item_product_id,
        round(sum(oi.order_item_subtotal), 2) AS revenue
    FROM retail.orders AS o
        JOIN retail.order_items AS oi
        ON o.order_id = oi.order_item_order_id
    WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    GROUP BY 1, 2
) SELECT * FROM (
    SELECT format_date('%Y%m', order_date) AS order_month,
        order_date,
        order_item_product_id,
        revenue,
        dense_rank() OVER (
            PARTITION BY order_date
            ORDER BY revenue DESC
        ) AS drank
    FROM daily_product_revenue
) WHERE drank <= 3  
ORDER BY 2, 4 DESC
```

## Overview of Key Integrations with Google BigQuery
Let us get an overview of Key Integrations with Google BigQuery.
* Integration with GCS
* Integration with External Databases such as Cloud SQL
* Spark Connector on Dataproc (Covered as part of subsequent modules)
* Programming Languages such as Python

## Python Pandas Integration with Google BigQuery
Let us get an overview of Python Pandas Integration with Google BigQuery.
* We need to install `pandas`, `pandas-gbq` and `google-cloud-bigquery` to get data from Google BigQuery table into Pandas Dataframe.
* Once all the required libraries installed, we can use `pd.read_gbq` by passing query as argument.

```python
import pandas as pd
query = '''
    SELECT order_status, count(*) AS order_count
    FROM `itversity-rnd.retail.orders`
    GROUP BY 1
    ORDER BY 2 DESC
'''
project_id = 'itversity-rnd'
df = pd.read_gbq(query, project_id=project_id)
df
```

## Integration of BigQuery with Cloud SQL
Let us get an overview of Integration of BigQuery with Cloud SQL (Postgresql).
* Click on **ADD DATA** and choose **External data source**.
* Use the instance connection name (from Cloud SQL) and credentials to add the external data source.
* Run queries using `EXTERNAL_QUERY` function in `FROM` clause. We need to pass the external connection and valid postgres query as arguments to `EXTERNAL_QUERY`.

```sql
SELECT * 
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT * FROM information_schema.tables WHERE table_schema = 'public'"
);

SELECT * 
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT order_date, count(*) AS order_count FROM orders GROUP BY 1 ORDER BY 2 DESC"
);

SELECT *
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT * FROM products"  
) AS p;

SELECT o.order_date,
  oi.order_item_product_id,
  p.product_name,
  round(sum(oi.order_item_subtotal)) AS revenue
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT * FROM products"  
) AS p 
  JOIN retail.order_items AS oi
    ON p.product_id = oi.order_item_product_id
  JOIN retail.orders AS o
    ON oi.order_item_order_id = o.order_id
GROUP BY 1, 2, 3
ORDER BY 1, 4 DESC;
```