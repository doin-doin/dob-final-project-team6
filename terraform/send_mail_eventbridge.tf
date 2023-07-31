# EventBridge Rule for Custom Action
resource "aws_cloudwatch_event_rule" "custom_action_rule" {
  name        = "MyCustomActionRule"
  description = "My Custom Action Rule"
  event_pattern = <<EOF
{
  "source": ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": [
    "${aws_securityhub_action_target.custom_action_target.arn}"
  ]
}
EOF
tags = {
    "Name" = "send_mail_rule",
    "Env"  = "Prod",
    "Type" = "rule",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

# EventBridge Rule Target (SNS Topic)
resource "aws_cloudwatch_event_target" "eventbridge_target_sns_for_mail" {
  rule = aws_cloudwatch_event_rule.custom_action_rule.name
  arn  = aws_sns_topic.sns_topic_for_mail.arn
}