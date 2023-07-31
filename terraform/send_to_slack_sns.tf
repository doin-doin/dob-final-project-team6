# SNS Topic
resource "aws_sns_topic" "sns_topic" {
  name = "security_hub_notifications"

  tags = {
    "Name" = "sns_topic_for_send_to_slack",
    "Env"  = "Prod",
    "Type" = "sns",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

# SNS Topic Subscription (SQS Queue)
resource "aws_sns_topic_subscription" "sns_subscription_send_to_slack" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue.arn
}

# Create SNS topic policy to allow Eventbridge to publish to the SNS topic
resource "aws_sns_topic_policy" "sns_send_to_slack" {
  arn    = aws_sns_topic.sns_topic.arn
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
      "Resource": "${aws_sns_topic.sns_topic.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_cloudwatch_event_rule.eventbridge_rule.arn}"
        }
      }
    }
  ]
}
POLICY  
}