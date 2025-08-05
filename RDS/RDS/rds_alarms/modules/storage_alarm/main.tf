resource "aws_cloudwatch_metric_alarm" "disk" {
  for_each = toset(var.rds_instances)

  alarm_name          = "RDS-${each.value}-Low-FreeStorage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.threshold
  alarm_description   = "RDS instance ${each.value} has low disk space"
  dimensions = {
    DBInstanceIdentifier = each.value
  }
  actions_enabled = true
  alarm_actions       = ["arn:aws:sns:ap-south-1:980636705122:rds-cross-ac"]
  treat_missing_data = "notBreaching"
}