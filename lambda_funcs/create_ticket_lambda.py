import json
import boto3
from botocore.exceptions import ClientError


def handler(event, context):


    def handler(event, context):
        dynamodb = boto3.resource("dynamodb")
        table = dynamodb.Table("ticket-table")

        try:
            body = json.loads(event["body"])

            userId = body.get("userId")
            item = body.get("item")

            if userId:
                table.put_item(
                    Item=item
                )
                return {
                    "statusCode": 200,
                    "body": json.dumps("Uploaded successfully")
                    }
            else:
                return {
                    "statusCode": 200,
                    "body": json.dumps("Something wasn't right")
                    }
        except ClientError:
            return {
                "statusCode": 500,
                "body": json.dumps("Error")
            }