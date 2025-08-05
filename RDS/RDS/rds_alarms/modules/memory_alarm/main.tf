resource "aws_cloudwatch_metric_alarm" "memory" {
  for_each = toset(var.rds_instances)

  alarm_name          = "RDS-${each.value}-Low-FreeableMemory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.threshold
  alarm_description   = "RDS instance ${each.value} is low on Freeable Memory"
  alarm_actions       = ["arn:aws:sns:ap-south-1:980636705122:rds-ram-cross-ac"]
  dimensions = {
    DBInstanceIdentifier = each.value
  }
  actions_enabled = true
  treat_missing_data = "notBreaching"
}