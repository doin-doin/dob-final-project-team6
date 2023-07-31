# EventBridge Rule
resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  name        = "securityhub_finding_event_rule"
  description = "Rule for Security Hub findings events"
  event_pattern = <<EOF
{
  "source": ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Imported", "Security Hub Findings - Custom Action"]
}
EOF

tags = {
    "Name" = "send_to_slack_rule",
    "Env"  = "Prod",
    "Type" = "rule",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

# EventBridge Rule Target (SNS Topic)
resource "aws_cloudwatch_event_target" "eventbridge_target_sns" {
  rule = aws_cloudwatch_event_rule.eventbridge_rule.name
  arn  = aws_sns_topic.sns_topic.arn
}




