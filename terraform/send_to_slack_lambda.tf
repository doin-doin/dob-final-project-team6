# Lambda Function
resource "aws_lambda_function" "lambda_function_send_to_slack" {
  filename      = "${data.archive_file.send_to_slack_zip.output_path}"  # Lambda 함수 코드 파일
  function_name = "security_hub_notification_lambda"
  role          = aws_iam_role.lambda_role_send_to_slack.arn
  handler       = "send-to-slack.lambda_handler"
  runtime       = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.send_to_slack_zip.output_path)

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
  tags = {
    "Name" = "send_to_slack_rule",
    "Env"  = "Prod",
    "Type" = "lambda",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

data "archive_file" "send_to_slack_zip" {
  type        = "zip"
  source_dir  = "../lambda/send_to_slack"
  output_path = "../lambda_zip/send_to_slack.zip"
}

# Lambda Permission for SQS
resource "aws_lambda_permission" "lambda_permission_send_to_slack" {
  statement_id  = "AllowSQSInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_send_to_slack.function_name
  principal     = "sqs.amazonaws.com"

  source_arn = aws_sqs_queue.sqs_queue.arn
}

# Lambda Trigger (SQS Queue)
resource "aws_lambda_event_source_mapping" "lambda_trigger" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  function_name    = aws_lambda_function.lambda_function_send_to_slack.function_name
}
