import json
import boto3
import os
from datetime import datetime

def lambda_handler(event, context):
    print(event)
    findings = []

    for record in event['Records']:
        sns_message = json.loads(record['Sns']['Message'])
        findings.extend(sns_message['detail']['findings'])

    findings_count = len(findings)
    
    # 이메일로 전송할 보고서 형식의 HTML 코드 작성
    report_html = "<h1>Security Hub Findings Report</h1>"
    report_html += "<p>Total Findings: {}</p>".format(findings_count)
    report_html += "<p>Report Date: {}</p>".format(datetime.now().strftime("%Y-%m-%d"))

    
    for finding in findings:
        report_html += "<hr>"
        report_html += "<h2>{}</h2>".format(finding['Title'])
        report_html += "<p>Severity: {}</p>".format(finding['Severity']['Label'])
        report_html += "<p>Description: {}</p>".format(finding['Description'])
        report_html += "<p>Resource: {}</p>".format(finding['Resources'][0]['Id'])

    
    # 이메일 전송
    ses = boto3.client('ses')
    ses.send_email(
        Source= os.environ['SourceEmailAddress'],  # 이메일 발신자 주소
        Destination={
            'ToAddresses': [ os.environ['RecipientEmailAddress']]  # 이메일 수신자 주소
        },
        Message={
            'Subject': {
                'Data': 'Security Hub Findings Report'  # 이메일 제목
            },
            'Body': {
                'Html': {
                    'Data': report_html  # 보고서 형식의 HTML 코드
                }
            }
        }
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Email sent!')
    }
