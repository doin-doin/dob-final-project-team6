# CloudWatch Logs 그룹 생성
resource "aws_cloudwatch_log_group" "ssm_logs" {
  name = "SSM_LogsGroup"
  tags = {
    "Name"    = "SSM_CloudWatch_LogsGroup",
    "TEST"    = "SSM_CloudWatch_LogsGroup",
    "Env"     = "Prod",
    "Type"    = "Database",
    "Owner"   = "DevOps",
    "Privacy" = "Y"
  }
}

#ssm lambda Log 그룹 생성
resource "aws_cloudwatch_log_group" "ssm_Lambda_logs" {
  name = "/aws/lambda/SSM_Lambda_toSecurityHub"
  tags = {
    "Name"    = "ssm_Lambda_log"
    "TEST"    = "ssm_Lambda_log"
    "Env"     = "Prod",
    "Type"    = "Database",
    "Owner"   = "DevOps",
    "Privacy" = "Y"
  }
}

# CloudWatch Logs 구독 필터 생성
resource "aws_cloudwatch_log_subscription_filter" "lambda_logs_permission_filter" {
  name            = "SSM_LambdaLogspermissionFilter"
  log_group_name  = aws_cloudwatch_log_group.ssm_logs.name
  filter_pattern  = "Permission"
  destination_arn = aws_lambda_function.sm-wtlogs-sh-lambda.arn

  depends_on = [
    aws_cloudwatch_log_group.ssm_logs,
    aws_lambda_function.sm-wtlogs-sh-lambda
  ]
}
resource "aws_cloudwatch_log_subscription_filter" "lambda_logs_error_filter" {
  name            = "SSM_LambdaLogsErrorFilter"
  log_group_name  = aws_cloudwatch_log_group.ssm_logs.name
  filter_pattern  = "error"
  destination_arn = aws_lambda_function.sm-wtlogs-sh-lambda.arn

  depends_on = [
    aws_cloudwatch_log_group.ssm_logs,
    aws_lambda_function.sm-wtlogs-sh-lambda
  ]
}


