variable "rds_instances" {
  type = list(string)
}

variable "rds_events" {
  description = "List of RDS lifecycle events"
  type        = list(string)
  default     = ["stopped", "terminated", "rebooted"]
}

variable "sns_topic_arns" {
  description = "ARN of the SNS topic for EC2 state change notifications"
  type        = string
}