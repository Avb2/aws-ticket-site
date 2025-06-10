import json
import boto3
from botocore.exceptions import ClientError
from decimal import Decimal
import logging
import random

import uuid



dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("ticket-table")

def handler(event, context):
    try:
        body = json.loads(event.get("body"))
        
        user_id = body.get("UserId")
    

        if not (user_id):
            return {
                "statusCode": 400,
                "body": json.dumps("Missing UserId or TicketId")
            }

        item = {
            "UserId": user_id,
            "TicketId": random.randint(100,999999),
            "Status": int(body.get("Status", 0)),
            "CreatedAt": Decimal(int(body.get("CreatedAt", 0))),
            "Title": body.get("Title", "No Title"),
            "Description": body.get("Description", "No Description")
        }

        print("ITEM TO WRITE:", json.dumps(item, default=str))


        table.put_item(Item=item)

        return {
            "statusCode": 200,
            "body": json.dumps("Ticket created")
        }

    except Exception as e:
        print("Unhandled error:", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps("Internal error: " + str(e))
        }