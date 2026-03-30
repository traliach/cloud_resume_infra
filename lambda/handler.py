import json
import logging
import os

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

TABLE_NAME = os.environ["TABLE_NAME"]
COUNTER_ID = "visitors"

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(TABLE_NAME)


def lambda_handler(event, context):
    try:
        response = table.update_item(
            Key={"id": COUNTER_ID},
            UpdateExpression="ADD visit_count :inc",
            ExpressionAttributeValues={":inc": 1},
            ReturnValues="UPDATED_NEW",
        )
        count = int(response["Attributes"]["visit_count"])
        logger.info("Visitor count updated to %d", count)

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": f"https://{os.environ.get('ALLOWED_ORIGIN', '*')}",
            },
            "body": json.dumps({"count": count}),
        }

    except ClientError as e:
        logger.error("DynamoDB error: %s", e.response["Error"]["Message"])
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Failed to retrieve visitor count"}),
        }
