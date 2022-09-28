# Data Warehouse using Google BigQuery

## Overview of Google BigQuery

## Create Dataset and Tables in Google BigQuery
Let us go ahead and see how we can create Dataset and an empty table using Google BigQuery.

## Load Data into an Empty Table in Google BigQuery

## Create Tables using GCS Files in Google BigQuery
Let us go ahead and create table for `orders` using Web UI of Google BigQuery. The table will be created using GCS Files.
* After choosing Cloud Storage as source, we can specify column names like this as our data doesn't have header. We need to make sure the data type for `order_date` is defined as `TIMESTAMP`.
```
order_id:INTEGER,
order_date:TIMESTAMP,
order_customer_id: INTEGER,
order_status:STRING
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

## Cumulative Aggregations and Ranking using Google BigQuery

## Overview of Key Integrations with Google BigQuery

## Integration of Dataproc with Google BigQuery

## Python Pandas Integration with Google BigQuery