import json
import boto3
import os

s3 = boto3.client("s3")

SOURCE_BUCKET = os.environ.get("SOURCE_BUCKET")
TARGET_BUCKET = os.environ.get("TARGET_BUCKET")
INPUT_PREFIX = os.environ.get("INPUT_PREFIX", "")
OUTPUT_PREFIX = os.environ.get("OUTPUT_PREFIX", "")

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    for record in event.get("Records", []):
        s3_info = record.get("s3", {})
        bucket = s3_info.get("bucket", {}).get("name")
        key = s3_info.get("object", {}).get("key")

        if bucket != SOURCE_BUCKET or not key.startswith(INPUT_PREFIX):
            print(f"Skipping file from bucket '{bucket}' or key '{key}' not in input prefix.")
            continue

        try:
            # Read the original .tfstate file
            response = s3.get_object(Bucket=bucket, Key=key)
            original_content = response["Body"].read().decode("utf-8")
            original_state = json.loads(original_content)

            # Strip all resource info, keep outputs and metadata
            sanitized_state = {
                k: v for k, v in original_state.items() if k != "resources"
            }

            # Get the file name and build the output key
            filename = os.path.basename(key)
            output_key = f"{OUTPUT_PREFIX}{filename}"

            # Upload the sanitized file to the target bucket
            s3.put_object(
                Bucket=TARGET_BUCKET,
                Key=output_key,
                Body=json.dumps(sanitized_state, indent=2),
                ContentType="application/json"
            )

            print(f"Sanitized state written to s3://{TARGET_BUCKET}/{output_key}")

        except Exception as e:
            print(f"Error processing file '{key}': {str(e)}")

    return {
        "statusCode": 200,
        "body": json.dumps("Processing complete")
    }
