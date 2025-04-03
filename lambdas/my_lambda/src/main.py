import os
import json
import logging
import boto3
import time

# Initialize structured logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Optional: add log format if needed
if not logger.handlers:
    handler = logging.StreamHandler()
    formatter = logging.Formatter("[%(levelname)s] %(asctime)s - %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)

def lambda_handler(event, context):
    aws_region = os.getenv("REGION")
    function_name = context.function_name if context else "UnknownFunction"

    print(f"Lambda function '{function_name}' triggered in region {aws_region}")
    logger.info(f"Lambda function '{function_name}' triggered in region {aws_region}")

    # Log the full incoming event
    logger.info(f"Received event: {json.dumps(event)}")
    print("Event received:", json.dumps(event))

    # Dummy processing
    time.sleep(0.5)
    logger.info("Processing done.")
    print("Lambda completed successfully.")

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Hello from Lambda!",
            "region": aws_region
        })
    }
