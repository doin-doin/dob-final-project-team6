data "aws_caller_identity" "current" {}

resource "aws_iam_role" "AWS-SSMRoleForEC2" {
  name = "AWS-SSMRoleForEC2"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "SSMRolePolicyAttachment" {
  role       = aws_iam_role.AWS-SSMRoleForEC2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "SSMInstanceProfile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.AWS-SSMRoleForEC2.name
}



resource "aws_iam_role" "lambda_role" {
  name = "SSM_Lambda_Role"

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

# Lambda 함수에 대한 IAM 정책 추가
resource "aws_iam_policy" "lambda_policy" {
  name        = "Lambda_Permission"
  description = "IAM policy for Lambda function"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudWatchLogs",
      "Effect": "Allow",
      "Action": [
        "logs:PutSubscriptionFilter"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowSSM",
      "Effect": "Allow",
      "Action": [
        "ssm:CommandInvocation*",
        "ssm:ListCommandInvocations",
        "ssm:SendCommand",
        "ssm:ListCommands",
        "ssm:ListDocuments",
        "ssm:DescribeDocument",
        "ssm:GetCommandInvocation"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Lambda 함수에 대한 IAM 정책 연결
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Cloud Watch Log group -> Lambda 권한
resource "aws_iam_policy" "lambda_logs_policy" {
  name        = "Lambda_Logs_Permission"
  description = "IAM policy for Lambda function to access CloudWatch Logs"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudWatchLogs",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:FilterLogEvents"
      ],
      "Resource": "arn:aws:logs:ap-northeast-2:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${data.aws_lambda_function.ssmlambda_function.function_name}:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}

data "aws_lambda_function" "ssmlambda_function" {
  function_name = aws_lambda_function.sm-wtlogs-sh-lambda.function_name
}

resource "aws_iam_policy" "lambda_securityhub_importfindings_policy" {
  name        = "Lambda_SecurityHub_ImportFindings_Permission"
  description = "IAM policy for Lambda function to access SecurityHub"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBatchImportFindings",
            "Effect": "Allow",
            "Action": [
                "securityhub:BatchImportFindings"
            ],
            "Resource": "arn:aws:securityhub:ap-northeast-2::product/aws/securityhub"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_securityhub_importfindings_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_securityhub_importfindings_policy.arn
}

resource "aws_iam_policy" "lambda_securityhub_policy" {
  name        = "Lambda_SecurityHub_Permission"
  description = "IAM policy for Lambda function to access SecurityHub"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "securityhub:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "securityhub.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_securityhub_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_securityhub_policy.arn
}
