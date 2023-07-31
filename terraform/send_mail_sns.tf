# SNS Topic
resource "aws_sns_topic" "sns_topic_for_mail" {
  name = "sns_topic_for_mail"

  tags = {
    "Name" = "sns_topic_for_mail",
    "Env"  = "Prod",
    "Type" = "sns",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

# SNS Topic Subscription (SQS Queue)
resource "aws_sns_topic_subscription" "sns_subscription_send_mail" {
  topic_arn = aws_sns_topic.sns_topic_for_mail.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_function_send_mail.arn
}

# Create SNS topic policy to allow Eventbridge to publish to the SNS topic
resource "aws_sns_topic_policy" "sns_send_mail" {
  arn    = aws_sns_topic.sns_topic_for_mail.arn
  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.sns_topic_for_mail.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_cloudwatch_event_rule.custom_action_rule.arn}"
        }
      }
    }
  ]
}
POLICY  
}