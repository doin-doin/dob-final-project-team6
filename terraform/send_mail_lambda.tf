# Lambda Function
resource "aws_lambda_function" "lambda_function_send_mail" {
  filename      = "${data.archive_file.send_mail_zip.output_path}"  # Lambda 함수 코드 파일
  function_name = "send_mail_lambda"
  role          = aws_iam_role.lambda_role_for_send_mail.arn
  handler       = "send-mail.lambda_handler"
  runtime       = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.send_mail_zip.output_path)
  

  environment {
    variables = {
      RecipientEmailAddress = var.RecipientEmailAddress,
      SourceEmailAddress = var.SourceEmailAddress
    }
  }
  tags = {
    "Name" = "send_mail_lambda",
    "Env"  = "Prod",
    "Type" = "lambda",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

data "archive_file" "send_mail_zip" {
  type        = "zip"
  source_dir  = "../lambda/send_mail"
  output_path = "../lambda_zip/send_mail.zip"
}

# Lambda Permission for SNS
resource "aws_lambda_permission" "lambda_permission_send_mail" {
  statement_id  = "AllowSNSInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_send_mail.function_name
  principal     = "sns.amazonaws.com"

  source_arn = aws_sns_topic.sns_topic_for_mail.arn
}

# # IAM Policy for SNS to invoke Lambda function
# resource "aws_iam_policy" "sns_lambda_policy" {
#   name        = "sns-lambda-policy"
#   description = "Policy for SNS to invoke Lambda function"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "AllowSnsToInvokeLambda",
#       "Effect": "Allow",
#       "Action": [
#         "lambda:InvokeFunction"
#       ],
#       "Resource": "${aws_lambda_function.lambda_function.arn}"
#     }
#   ]
# }
# EOF
# }

# # IAM Role for SNS
# resource "aws_iam_role" "sns_role" {
#   name = "MySnsRole"
#   # Configure SNS role policies
# }

# # IAM Policy Attachment for SNS Role
# resource "aws_iam_role_policy_attachment" "sns_policy_attachment" {
#   role       = aws_iam_role.sns_role.name
#   policy_arn = aws_iam_policy.sns_lambda_policy.arn
# }
