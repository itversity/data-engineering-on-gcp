import json
import os
import pandas as pd

from google.cloud import storage

def get_columns(schemas_blob, ds_name):
    schemas = json.loads(schemas_blob.download_as_string())
    column_details = sorted(schemas[ds_name], key=lambda col: col['column_position'])
    columns = list(map(lambda td: td['column_name'], column_details))
    return columns


def main(event, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    src_bucket_name = os.environ.get('SRC_BUCKET_NAME')
    tgt_bucket_name = os.environ.get('TGT_BUCKET_NAME')
    base_dir = os.environ.get('BASE_DIR')
    gsclient = storage.Client()
    src_bucket = gsclient.get_bucket(src_bucket_name)
    schemas_blob = src_bucket.get_blob(f'{base_dir}/schemas.json')
    blobs = gsclient.list_blobs(
        src_bucket_name,
        prefix=base_dir
    )
    for blob in blobs:
        if blob.name.split('/')[-1].startswith('part-'):
            print(blob.name)
            ds_name = blob.name.split('/')[-2]
            columns = get_columns(schemas_blob, ds_name)
            df = pd.read_csv(f'gs://{src_bucket_name}/{blob.name}', names=columns)
            df.to_parquet(f'gs://{tgt_bucket_name}/{blob.name}.snappy.parquet')