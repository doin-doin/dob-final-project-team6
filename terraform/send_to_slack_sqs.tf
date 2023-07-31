# SQS Queue
resource "aws_sqs_queue" "sqs_queue" {
  name = "security_hub_notifications_queue"

  tags = {
    "Name" = "sqs_queue_for_send_to_slack",
    "Env"  = "Prod",
    "Type" = "sqs",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

# SNS Subscription policy
data "aws_iam_policy_document" "sns-sqs-policy" {
  statement {
    sid     = "SNSPublish"
    effect = "Allow"

    actions = ["SQS:SendMessage"]
    resources = [aws_sqs_queue.sqs_queue.arn]

    principals {
        type        = "AWS"
        identifiers = ["*"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.sns_topic.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sns-sqs-policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sns-sqs-policy.json
}