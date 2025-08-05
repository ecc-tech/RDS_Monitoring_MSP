resource "aws_cloudwatch_metric_alarm" "cpu" {
  for_each = toset(var.rds_instances)

  alarm_name          = "RDS-${each.value}-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.threshold
  alarm_description   = "RDS instance ${each.value} CPU usage too high"
  alarm_actions       = ["arn:aws:sns:ap-south-1:980636705122:rds-cross-ac"]
  dimensions = {
    DBInstanceIdentifier = each.value
  }
  actions_enabled = true
  treat_missing_data = "notBreaching"
}