import boto3
from datetime import datetime, timedelta

def get_aws_account_id():
    sts_client = boto3.client('sts')
    response = sts_client.get_caller_identity()
    account_id = response['Account']
    return account_id

def lambda_handler(event, context):
    # 필터링할 CloudWatch 로그 그룹
    log_group_name = "SSM_LogsGroup"

    # AWS Account ID 가져오기
    AWS_ACCOUNT_ID = get_aws_account_id()

    # CloudWatch Logs 클라이언트 생성
    logs_client = boto3.client("logs")

    # SecurityHub 클라이언트 생성
    securityhub_client = boto3.client("securityhub")

    # 로그 스트림을 가져올 시간 범위 (기본적으로 최근 1시간)
    end_time = datetime.now()
    start_time = end_time - timedelta(hours=1)

    # 로그 필터링 표현식
    filter_pattern = "error"

    try:
        # CloudWatch Logs에 필터링된 로그 조회
        response = logs_client.filter_log_events(
            logGroupName=log_group_name,
            startTime=int(start_time.timestamp()) * 1000,
            endTime=int(end_time.timestamp()) * 1000,
            filterPattern=filter_pattern
        )

        # 필터링된 로그가 존재하는 경우 SecurityHub에 Finding 생성
        if response["events"]:
            findings = []
            for event in response["events"]:
                log_data = {
                    "SchemaVersion": "2018-10-08",
                    "Id": event["eventId"],
                    "ProductArn": f"arn:aws:securityhub:ap-northeast-2:{AWS_ACCOUNT_ID}:product/{AWS_ACCOUNT_ID}/default",
                    "GeneratorId": "lambda_function",
                    "AwsAccountId": AWS_ACCOUNT_ID,
                    "Types": ["Software and Configuration Checks/AWS Security Best Practices"],
                    "CreatedAt": datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'),
                    "UpdatedAt": datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'),
                    "Severity": {
                        "Normalized": 5,
                        "Product": 3
                    },
                    "Title": "Error Log",
                    "Description": event["message"],
                    "Resources": [
                        {
                            "Type": "Other",
                            "Id": "cloudwatch-log-event",
                            "Details": {
                                "Other": {
                                    "LogGroup": log_group_name,
                                    "LogStream": event["logStreamName"],
                                    "EventId": event["eventId"]
                                }
                            }
                        }
                    ]
                }
                findings.append(log_data)

            # SecurityHub에 Finding 생성
            securityhub_client.batch_import_findings(
                Findings=findings
            )

        return {
            "statusCode": 200,
            "body": "Success"
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": str(e)
        }
