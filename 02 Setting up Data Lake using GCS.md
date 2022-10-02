# Setting up Data Lake using GCS

## Getting Started with GCS
Let us get started with GCS or Google Cloud Storage.
* GCS is reliable and secure object storage.

Here are some of the key features of GCS.
* Low cost object storage, which is accessible from any where.
* Supports lower-cost classes.
  * Standard (frequent data)
  * Nearline (backups)
  * Coldline (older backups)
  * Archive (regulatory archives)
* Multiple redundancy options for high availability or reliability.
* Easy transfer of Data to Cloud Storage using Storage Transfer Service.

You can review details about GCS by followig [official documentation](https://cloud.google.com/storage).

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
* Bucket Name: `aibucketui`.
* Upload `retail_db` folder to GCS using Web UI.

## Overview of gsutil

`gsutil` is command line util to manage buckets, folders and files in Google Cloud Storage.
*  `gsutil help` can be used to get help.
* Here are the most important commands to manage buckets, folders and files using `gsutil`.
* We have used **Cloud Shell** to run `gsutil` commands for the demo. Here are the commands we have used for the demo related to get started with `gsutil`.

```shell
gsutil list # list the objects
gsutil # list the subcommands under gsutil
gsutil ls gs://aibucketui # to list folders in the bucket

gsutil help ls # to get usage or help on ls or list command

gsutil ls -r gs://aibucketui # to list files and folders recursively
```

## Setup Data Repository in Google Cloud Shell
Here are the details to setup data repository in Google Cloud Shell.
* Clone our [data repository](https://github.com/dgadiraju/data) from GitHub.
* You can use following command to clone the repository.

```shell
git clone https://github.com/dgadiraju/data
```

* You can review the retail files in the data folder by running `find data/retail_db`
* You can also use `ls -ltr data` to list all the data sets that are available in our GitHub repository.

## Overview of Data Sets

Let us get a quick overview about data sets.
* Data Sets are part of our GitHub repository.
* If you have already setup GitHub repository, you should see `data` folder.
* We will use these data sets as part of different sections or modules in this course.

## Manage Files in GCS using gsutil commands
Let me demonstrate how to manage files in `aidldemo` bucket. Make sure to replace ai with your initials to make the bucket name unique.
* Delete the bucket, if it exists (we need to empty the folder first).
* Create the bucket.
* Add `data/retail_db` recursively to `gs://aidldemo/data/retail_db` recursively.
* Review all the files in `data/retail_db` and also `gs:/aidldemo/data/retail_db`.
* Make sure all the files are successfully copied.
* Here are some of the important commands we can use to manage buckets, folders as well as files.

|Command|Description|
|---|---|
|`gsutil mb gs://aidldemo`|To create bucket|
|`gsutil rb gs://aidldemo`|To remove bucket|
|`gsutil list gs://aidldemo`|To list files and folders in `aidldemo` bucket|
|`gsutil list -r gs://aidldemo`|To list all files and folders recursively in `aidldemo` bucket|
|`gsutil ls`|`ls` and `list` are aliases|
|`gsutil help ls` or `gs help list`|To get help on `ls` or `list` commands|
|`gsutil cp -r data/retail_db gs://aidldemo/data/retail_db`|To copy `retail_db` folder recursively from local file system to GCS Bucket in specified path|
|`gsutil rm -r gs://aidldemo/data/retail_db`|To delete `retail_db` folder recursively from specified path in GCS|

## Copy Retail Data Set to GCS using gsutil commands
Take it as an exercise and make sure to copy `data/retail_db_json` recursively to `gs://aidldemo/data/retail_db_json`.
* Copy the folder recursively to existing bucket.
* Review if all the files are successfully copied or not.

## Manage Files in GCS using Python
Let us see how we can manage files in GCS using Python as Programming Language.
* We need to first make sure Google Cloud SDK (includes gsutil) is setup and configured.
* Install `google-cloud-storage` Python library using `pip`.
* We need to make sure the storage module is imported and the client is created.
* Using storage client we will be able to manage buckets as well as files (blobs) in GCS using Python

Refer to the Notebook which have few examples related to managing files in GCS using Python.

## Overview of processing data in GCS using Pandas
Let us see how we can process data in GCS using Pandas.
* Pandas is the most popular library used to process as well as analyze the data.
* We can seamlessly read data from GCS Files as well as write data to GCS Files using Pandas.
* We need to have `pandas` and `gcsfs` installed using pip in the same virtual environment so that Pandas can be used to process data in GCS Files.
* At times we might have to install additional libraries to process data using particular format (for eg: pyarrow needs to be installed to work with Parquet).

Refer to the Notebook which have few examples related to reading CSV files in GCS using Pandas and then writing the data into Parquet files in GCS.