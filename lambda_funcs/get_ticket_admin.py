import json
import boto3
from decimal import Decimal
from boto3.dynamodb.conditions import Key, Attr


class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            try:
                return float(o) if o % 1 else int(o)
            except:
                return str(o)
        return super(DecimalEncoder, self).default(o)


def handler(event, context):
    dynamodb = boto3.resource("dynamodb", region_name="us-east-2")
    table = dynamodb.Table("ticket-table")

    try:
        response = table.scan(
        FilterExpression=Attr('Status').ne(0)
        )
       
        return {
            "statusCode": 200,
            "body": json.dumps(response["Items"], cls=DecimalEncoder)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
