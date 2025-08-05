# Create event rules per RDS instance and per event
locals {
  rds_emergency_events = toset(["stop", "terminate"])

  rds_priority_map = {
    "stop"      = "emergency"
    "terminate" = "emergency"
    "reboot"    = "warning"
  }

  rds_sns_topic_arn = "arn:aws:sns:ap-south-1:980636705122:rds-state-change"
}
resource "aws_cloudwatch_event_rule" "rds_state_rule" {
  for_each = {
    for pair in flatten([
      for db_id in var.rds_instances : [
        for event in var.rds_events : {
          key     = "${db_id}-${event}"
          db_id   = db_id
          event   = event
        }
      ]
    ]) : pair.key => pair
  }

  name        = "${each.value.db_id}-${each.value.event}-rule"
  description = "Rule for RDS ${each.value.event} on instance ${each.value.db_id}"

  event_pattern = jsonencode({
    source        = ["aws.rds"],
    "detail-type" = ["RDS DB Instance Event"],
    detail = {
      SourceIdentifier = [each.value.db_id],
      EventCategories  = ["availability"]
    }
  })
}


# Target for each rule
resource "aws_cloudwatch_event_target" "rds_state_target" {
  for_each = aws_cloudwatch_event_rule.rds_state_rule

  rule      = each.value.name
  target_id = "${each.key}-target"
  arn       = local.rds_sns_topic_arn
  role_arn  = aws_iam_role.eventbridge_to_sns.arn
}

# IAM Role reused or you can duplicate if needed
resource "aws_iam_role" "eventbridge_to_sns" {
  name = "rds-eventbridge-to-sns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_to_sns_policy" {
  name = "rds-eventbridge-to-sns-policy"
  role = aws_iam_role.eventbridge_to_sns.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sns:Publish",
      Resource = local.rds_sns_topic_arn
    }]
  })
}