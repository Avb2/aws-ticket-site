import json
import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError
import time
import os


def handler(event, context):


    def handler(event, context):
        dynamodb = boto3.resource("dynamodb")
        sns_topic = boto3.resource("sns")
        table = dynamodb.Table("ticket-table")
        topic_arn = os.environ['SNS_TOPIC_ARN']

        try:
            body = json.loads(event["body"])

            userId = body.get("userId")

            if userId:
                timeCheck = time.time() - 2880

                response = table.scan(
                    IndexName="query_unchecked_tickets",
                    KeyConditionExpression=Key('Status').eq(1) & Key('CreatedAt').lt(timeCheck),
                )

                sns_topic.publish(
                    TopicArn=topic_arn,
                    Protocol='email',
                    Endpoint='bringuel.alexander@gmail.com'
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