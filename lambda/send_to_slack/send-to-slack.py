import json
import os
import urllib.request

SLACK_WEBHOOK_URL = os.environ['SLACK_WEBHOOK_URL']

def send_slack_notification(message):
    payload = {
        'text': message,
        'username': 'Security Hub Bot',
        'icon_emoji': ':warning:'
    }
    headers = {'Content-Type': 'application/json'}
    req = urllib.request.Request(
        SLACK_WEBHOOK_URL,
        data=json.dumps(payload).encode('utf-8'),
        headers=headers,
        method='POST'
    )
    try:
        with urllib.request.urlopen(req) as response:
            response.read()
            print("Slack notification sent successfully")
    except Exception as e:
        print("Error sending Slack notification: ", str(e))

def lambda_handler(event, context):
    sqs_message = json.loads(event['Records'][0]['body'])['Message']
    findings = json.loads(sqs_message)['detail']['findings']

    report = ""
    for finding in findings:
        title = finding['Title']
        severity = finding['Severity']['Label']
        description = finding['Description']
        resource = finding['Resources'][0]['Id']

        report += f"Title: {title}\nSeverity: {severity}\nDescription: {description}\nResource: {resource}\n\n"

    send_slack_notification(report)

    return {
        'statusCode': 200,
        'body': json.dumps('Slack notification sent!')
    }
