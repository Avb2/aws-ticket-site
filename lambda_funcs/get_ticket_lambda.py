import json
import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError


def handler(event, context):
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("ticket-table")

    try:
        body = json.loads(event["body"])

        userId = body.get("userId")

        if userId:
            response = table.query(
                KeyConditionExpression=Key('UserId').eq(userId)
            )
            return {
                "statusCode": 200,
                "body": json.dumps(response["Items"])
                }
        else:
            return {
                "statusCode": 200,
                "body": json.dumps([])
                }
    except ClientError:
        return {
            "statusCode": 500,
            "body": json.dumps("Error")
        }