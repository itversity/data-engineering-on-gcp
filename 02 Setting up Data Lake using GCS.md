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
|`gs list gs://aidedemo`|To list files and folders in **airetail** bucket|
|`gs list -r gs://aidedemo`|To list all files and folders recursively in **airetail** bucket|
|`gs ls`|`ls` and `list` are aliases|
|`gs help ls` or `gs help list`|To get help on `ls` or `list` commands|
|`gs cp -r data/retail_db gs://aidedemo/data/retail_db`|To copy `retail_db` folder recursively from local file system to GCS Bucket in specified path|
|`gs rm -r gs://aidedemo/data/retail_db`|To delete `retail_db` folder recursively from specified path in GCS|


## Overview of Data Sets

## Manage Files in GCS using gsutil commands

## Copy Retail Data Set to GCS using gsutil commands

## Manage Files in GCS using Python

## Overview of processing data in GCS using Pandas