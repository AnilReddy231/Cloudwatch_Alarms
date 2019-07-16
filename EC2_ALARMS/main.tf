data "aws_caller_identity" "current" {}

# Make a topic
resource "aws_sns_topic" "ec2" {
    name = "ec2-threshold-alerts"
}

data "aws_iam_policy_document" "ec2_sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    sid = "__default_statement_ID"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect    = "Allow"
    resources = ["${aws_sns_topic.ec2.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "${data.aws_caller_identity.current.account_id}",
      ]
    }
  }

  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.ec2.arn}"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow EC2 Event Notification"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.ec2.arn}"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_sns_topic_policy" "ec2" {
  arn    = "${aws_sns_topic.ec2.arn}"
  policy = "${data.aws_iam_policy_document.ec2_sns_topic_policy.json}"
}