import logging
import os
from pathlib import Path

import boto3
from botocore.exceptions import ClientError
from dotenv import load_dotenv


load_dotenv()

RAW_DIR = Path("data/raw")

AWS_REGION = os.getenv("AWS_REGION")
S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME")


def upload_file(file_name, bucket, object_name=None):
    """
    Upload a file to an S3 bucket.

    This function is adapted from the Boto3 documentation.

    :param file_name: Local file to upload
    :param bucket: S3 bucket to upload to
    :param object_name: S3 object path/name. If not specified, file_name is used.
    :return: True if file was uploaded, else False
    """

    if object_name is None:
        object_name = os.path.basename(file_name)

    s3_client = boto3.client("s3", region_name=AWS_REGION)

    try:
        s3_client.upload_file(file_name, bucket, object_name)
    except ClientError as error:
        logging.error(error)
        return False

    return True


def main():
    if not S3_BUCKET_NAME:
        raise ValueError("S3_BUCKET_NAME is missing. Check your .env file.")

    json_files = list(RAW_DIR.glob("*.json"))

    if not json_files:
        print("No JSON files found in data/raw.")
        return

    print(f"Found {len(json_files)} JSON files to upload.")

    for file_path in json_files:
        s3_key = f"weather/raw/{file_path.name}"

        print(f"Uploading {file_path} to s3://{S3_BUCKET_NAME}/{s3_key}")

        success = upload_file(
            file_name=str(file_path),
            bucket=S3_BUCKET_NAME,
            object_name=s3_key
        )

        if success:
            print("Upload complete.")
        else:
            print("Upload failed.")


if __name__ == "__main__":
    main()
