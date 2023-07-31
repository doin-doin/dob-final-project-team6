resource "aws_lambda_function" "sm-wtlogs-sh-lambda" {
  function_name = "SSM_Lambda_toSecurityHub"
  role          = aws_iam_role.lambda_role.arn
  handler       = "sm-wtlogs-sh-lambda.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.sm-wtlogs-sh-lambda_zip.output_path
  # filename         = "${path.module}/lambda_zip/ssmLambda.zip"
  source_code_hash = filebase64sha256(data.archive_file.sm-wtlogs-sh-lambda_zip.output_path)

  environment {
    variables = {
      SECURITY_HUB_REGION = "ap-northeast-2"
    }
  }
  tags = {
    "Name"    = "sm-wtlogs-sh-lambda",
    "TEST"    = "sm-wtlogs-sh-lambda",
    "Env"     = "Prod",
    "Type"    = "lambda",
    "Owner"   = "DevOps",
    "Privacy" = "Y"
  }
}

data "archive_file" "sm-wtlogs-sh-lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda/CCE"
  output_path = "../lambda_zip/sm-wtlogs-sh-lambdazip"
}


resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sm-wtlogs-sh-lambda.function_name
  principal     = "logs.amazonaws.com"
  # :* 필수로 붙여야함...
  source_arn = "${aws_cloudwatch_log_group.ssm_logs.arn}:*"
}


