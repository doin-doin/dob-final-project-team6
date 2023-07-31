variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID for User"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key for User"
  type        = string
}

variable "SourceEmailAddress" {
    description = "SourceEmailAddress"
    type = string
    default = "SourceEmailAddress@gmail.com" # 발신 메일
}

variable "RecipientEmailAddress" {
    description = "RecipientEmailAddress"
    type = string
    default = "RecipientEmailAddress@gmail.com"   #수신 메일
}

variable "aws_region" {
    description = "aws region"
    type = string
    default = "ap-northeast-2"
}

variable "slack_webhook_url" {
    description = "SLACK_WEBHOOK_URL"
    type = string
    default = "https://hooks.slack.com/services/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"
}