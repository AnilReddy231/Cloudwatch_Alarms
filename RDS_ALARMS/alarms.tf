locals {
  thresholds = {
    CPUUtilizationThreshold   = "${min(max(var.cpu_utilization_threshold, 60), 100)}"
    CPUCreditBalanceThreshold = "${max(var.cpu_credit_balance_threshold, 35)}"
    DiskQueueDepthThreshold   = "${max(var.disk_queue_depth_threshold, 0)}"
    FreeableMemoryThreshold   = "${max(var.freeable_memory_threshold, 0)}"
    FreeStorageSpaceThreshold = "${max(var.free_storage_space_threshold, 0)}"
    }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "high_cpu_utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["CPUUtilizationThreshold"]}"
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = ["${aws_sns_topic.rds.arn}"]
  ok_actions          = ["${aws_sns_topic.rds.arn}"]

  dimensions = {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  alarm_name          = "low_cpu_credit_balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["CPUCreditBalanceThreshold"]}"
  alarm_description   = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon"
  alarm_actions       = ["${aws_sns_topic.rds.arn}"]
  ok_actions          = ["${aws_sns_topic.rds.arn}"]

  dimensions = {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_disk_queue_depth" {
  alarm_name          = "high_disk_queue_depth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["DiskQueueDepthThreshold"]}"
  alarm_description   = "Average database disk queue depth over last 10 minutes too high, performance may suffer"
  alarm_actions       = ["${aws_sns_topic.rds.arn}"]
  ok_actions          = ["${aws_sns_topic.rds.arn}"]

  dimensions = {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_freeable_memory" {
  alarm_name          = "low_freeable_memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["FreeableMemoryThreshold"]}"
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = ["${aws_sns_topic.rds.arn}"]
  ok_actions          = ["${aws_sns_topic.rds.arn}"]

  dimensions = {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "low_free_storage_space" {
  alarm_name          = "low_free_storage_space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${local.thresholds["FreeStorageSpaceThreshold"]}"
  alarm_description   = "Average database free storage space over last 10 minutes too low"
  alarm_actions       = ["${aws_sns_topic.rds.arn}"]
  ok_actions          = ["${aws_sns_topic.rds.arn}"]

  dimensions = {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

data "template_file" "output_log"{
  template = "${path.module}/output.log"
}

resource "null_resource" "mail_subscription" {
  count = length(var.alarm_emails)
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${aws_sns_topic.rds.arn} --protocol email --notification-endpoint ${element(var.alarm_emails, count.index)} --region ${var.regions["east-2"]} >> ${data.template_file.output_log.rendered}"
  }
}

