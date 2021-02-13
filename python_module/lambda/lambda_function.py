import json


def lambda_handler(event, context):
    print(event)

    if event['httpMethod'] != 'GET':
        return {
            'statusCode': 400,
            'body': json.dumps('Not supported')
        }

    elif event['body'] == None:
        return {
            'statusCode': 400,
            'body': json.dumps('No journal included')
        }

    else:
        return {
            'statusCode': 200,
            'body': json.dumps('Journal sentiment info')
        }
