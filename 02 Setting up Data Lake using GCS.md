# Setting up Data Lake using GCS

## Getting Started with GCS

## Overview of GCS Web UI

Let us get an overview of GCS Web UI.
* We can use GCS Web UI to get started with Google Cloud Storage Quickly.
* Following are the common tasks using GCS Web UI.
  * Manage Buckets.
  * Upload Files and Folders from Local File System to GCS.
  * Reiew the details of Files and Folders.
  * Delete Files and Folders from GCS.
* Even though it is easy to start with GCS, it is not good idea to use in projects. We typically use Commands or Programming Language SDKs.

## Setup GCS Bucket and Upload Files

As part of this lecture, we will setup GCS Bucket and upload files from local file system to GCP Bucket.
* Bucket Name: `airetail`.
* Upload `retail_db` folder to GCS using Web UI.

## Overview of gsutil

`gsutil` is command line util to manage buckets, folders and files in Google Cloud Storage.
*  `gsutil help` can be used to get help.
* Here are the most important commands to manage buckets, folders and files using `gsutil`.

|Command|Description|
|---|---|
|`gs mb gs://aidedemo`|To create bucket|
|`gs rb gs://aidedemo`|To remove bucket|
|`gs list gs://aidedemo`|To list files and folders in `aidedemo` bucket|
|`gs list -r gs://aidedemo`|To list all files and folders recursively in `aidedemo` bucket|
|`gs ls`|`ls` and `list` are aliases|
|`gs help ls` or `gs help list`|To get help on `ls` or `list` commands|
|`gs cp -r data/retail_db gs://aidedemo/data/retail_db`|To copy `retail_db` folder recursively from local file system to GCS Bucket in specified path|
|`gs rm -r gs://aidedemo/data/retail_db`|To delete `retail_db` folder recursively from specified path in GCS|

## Overview of Data Sets

Let us get a quick overview about data sets.
* Data Sets are part of our GitHub repository.
* If you have already setup GitHub repository, you should see `data` folder.
* We will use these data sets during the course of the course.

## Manage Files in GCS using gsutil commands
Let me demonstrate how to manage files in `aidedemo` bucket.
* Delete the bucket, if it exists (we need to empty the folder first).
* Create the bucket.
* Add `data/retail_db` recursively to `gs:/aidedemo/data/retail_db` recursively.
* Review all the files in `data/retail_db` and also `gs:/aidedemo/data/retail_db`.
* Make sure all the files are successfully copied.

## Copy Retail Data Set to GCS using gsutil commands
Take it as an exercise and make sure to copy `data/retail_db_json` recursively to `gs:/aidedemo/data/retail_db_json`.
* Copy the folder recursively to existing bucket.
* Review if all the files are successfully copied or not.

## Manage Files in GCS using Python

## Overview of processing data in GCS using Pandas