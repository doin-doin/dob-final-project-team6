# Security Hub Custom Action
resource "aws_securityhub_action_target" "custom_action_target" {
  name        = "Send-mail"
  description = "Send Daily Report"
  identifier =  "sendmail"

  # Configure custom action properties
}
