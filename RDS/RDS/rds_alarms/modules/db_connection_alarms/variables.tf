variable "rds_instances" {
  description = "List of RDS instance identifiers"
  type        = list(string)
}

variable "connection_threshold" {
  description = "Threshold for DB connections"
  type        = number
}

# Uncomment if you're using alarm actions
# variable "alarm_actions" {
#   description = "SNS topic ARNs for alarms"
#   type        = list(string)
# }
