resource "aws_cloudwatch_metric_alarm" "db_connection_high" {
  for_each = toset(var.rds_instances)

  alarm_name          = "RDS-${each.value}-DB-connect"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.connection_threshold
  alarm_description   = "Alarm when DB connections exceed threshold"
  alarm_actions       = ["arn:aws:sns:ap-south-1:980636705122:rds-db-connection"]
  actions_enabled = true
  treat_missing_data = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = each.value
  }


  
}
