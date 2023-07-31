# IAM Role for Lambda Function
resource "aws_iam_role" "lambda_role_for_send_mail" {
  name = "lambda_execution_role_for_send_mail"
  
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
# IAM Policy for Lambda to send email using SES
resource "aws_iam_policy" "lambda_ses_policy" {
  name        = "lambda-ses-policy"
  description = "Policy for Lambda to send email using SES"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLambdaToSendEmail",
      "Effect": "Allow",
      "Action": [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


# Attach AWSLambdaBasicExecutionRole managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_basic_policy_attachment_send_mail" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role_for_send_mail.name
}

# Attach policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_send_mail_policy_attachment_send_mail" {
  policy_arn = aws_iam_policy.lambda_ses_policy.arn
  role       = aws_iam_role.lambda_role_for_send_mail.name
}
