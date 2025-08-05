variable "region" {
  type    = string
  default = "us-east-1"
}
variable "cpu_threshold" {
  type    = number
  default = 80
}
variable "memory_threshold" {
  type    = number
  
}
variable "disk_threshold" {
  type    = number
  
}
variable "rds_instance_ids" {
  type = list(string)
}
