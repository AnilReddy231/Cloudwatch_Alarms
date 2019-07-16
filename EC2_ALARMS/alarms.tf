locals {
  thresholds = {
    CPUUtilizationThreshold   = "${min(max(var.cpu_utilization_threshold, 60), 100)}"
    CPUCreditBalanceThreshold = "${max(var.cpu_credit_balance_threshold, 35)}"
    }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "high_cpu_utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["CPUUtilizationThreshold"]}"
  alarm_description   = "Average EC2 CPU utilization over last 10 minutes too high"
  alarm_actions       = ["${aws_sns_topic.ec2.arn}"]
  ok_actions          = ["${aws_sns_topic.ec2.arn}"]

  dimensions = {
    InstanceId = "${var.ec2_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "instance-health-check" {
  alarm_name          = "instance-health-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Health Check of EC2 is failing from last 2 mins "
  alarm_actions       = ["${aws_sns_topic.ec2.arn}"]
  ok_actions          = ["${aws_sns_topic.ec2.arn}"]

  dimensions = {
    InstanceId = "${var.ec2_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  alarm_name          = "low_cpu_credit_balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["CPUCreditBalanceThreshold"]}"
  alarm_description   = "Average EC2 CPU credit balance over last 10 minutes too low, may cause significant performance drop soon"
  alarm_actions        = ["${aws_sns_topic.ec2.arn}"]
  ok_actions          = ["${aws_sns_topic.ec2.arn}"]

  dimensions = {
    DBInstanceIdentifier = "${var.ec2_instance_id}"
  }
}


data "template_file" "output_log"{
  template = "${path.module}/output.log"
}

resource "null_resource" "mail_subscription" {
  count = length(var.alarm_emails)
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${aws_sns_topic.ec2.arn} --protocol email --notification-endpoint ${element(var.alarm_emails, count.index)} --region ${var.regions["east-2"]} >> ${data.template_file.output_log.rendered}"
  }
}