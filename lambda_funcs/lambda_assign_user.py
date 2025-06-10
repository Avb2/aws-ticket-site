import boto3
import botocore

def handler(event, context):
    client = boto3.client('cognito-idp')
    
    user_pool_id = event['userPoolId']
    username = event['userName']
    
    try:
        client.admin_add_user_to_group(
            UserPoolId=user_pool_id,
            Username=username,
            GroupName='User'
        )
    except botocore.exceptions.ClientError as error:
        print(f"Error adding user to group: {error}")
        raise error

    return event
