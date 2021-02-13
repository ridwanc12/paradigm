import json
import boto3


def sentiment_analysis(journal):
    comprehend = boto3.client(
        service_name='comprehend', region_name='us-east-2')
    sentiment = comprehend.detect_sentiment(Text=journal, LanguageCode='en')
    phrases = comprehend.detect_key_phrases(Text=journal, LanguageCode='en')
    subjects = comprehend.detect_entities(Text=journal, LanguageCode='en')
    return [sentiment, phrases, subjects]


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
        journal = event['body']
        results = sentiment_analysis(journal)
        print(results)
        return {
            'statusCode': 200,
            'body': json.dumps({'sentiment': results[0], 'phrases': results[1], 'subjects': results[2]})
        }
