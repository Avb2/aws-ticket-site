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
            ticketId = body.get("ticketId")

            if userId:
                table.update_item(
                    Key={
                        "UserId": userId,
                        "TicketId": ticketId
                    },
                    UpdateExpression = "set #s = :newStatus",
                    ExpressionAttributeNames={
                        "#s": "Status"
                    },
                    ExpressionAttributeValues={
                        ":newStatus": 1
                    }
                )
                return {
                    "statusCode": 200,
                    "body": json.dumps("Updated successfully")
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
        except Exception as e:
            print(e)
            return {
                "statusCode": 500,
                "body": json.dumps("Error")
            }