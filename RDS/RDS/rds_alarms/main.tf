provider "aws" {
  region = var.region
}


# ✅ Loop over each DB identifier and fetch detailed info
data "aws_db_instance" "db_info" {
  for_each = toset(var.rds_instance_ids)
  db_instance_identifier = each.key
}

module "cpu_alarms" {
  source        = "./modules/cpu_alarm"
  rds_instances = keys(data.aws_db_instance.db_info)
  threshold     = var.cpu_threshold
}

module "memory_alarms" {
  source        = "./modules/memory_alarm"
  rds_instances = keys(data.aws_db_instance.db_info)
  threshold     = var.memory_threshold
}

module "storage_alarms" {
  source        = "./modules/storage_alarm"
  rds_instances = keys(data.aws_db_instance.db_info)
  threshold     = var.disk_threshold
}

module "db_connection_alarm" {
  source               = "./modules/db_connection_alarms"
  rds_instances        = keys(data.aws_db_instance.db_info)
  connection_threshold = 5
  # alarm_actions      = [aws_sns_topic.alerts.arn]
}

module "rds_event_rules" {
  source         = "./modules/rds_events"
  rds_instances  = keys(data.aws_db_instance.db_info)
  rds_events     = ["stop", "terminate", "reboot"]
  sns_topic_arns = "arn:aws:sns:ap-south-1:980636705122:rds-cross-ac"
}
