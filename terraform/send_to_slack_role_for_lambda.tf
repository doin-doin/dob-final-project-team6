# IAM Role for Lambda Function
resource "aws_iam_role" "lambda_role_send_to_slack" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach AWSLambdaSQSQueueExecutionRole managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment_send_to_slack" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  role       = aws_iam_role.lambda_role_send_to_slack.name
}

# Attach AWSLambdaBasicExecutionRole managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_basic_policy_attachment_send_to_slack" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role_send_to_slack.name
}
