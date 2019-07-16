variable "alarm_emails" {
    type = "list"
}
variable "regions" {
    type = "map"
    default = {
        "east-1" = "us-east-1",
        "east-2" = "us-east-2",
        "west-1" = "us-west-1",
        "west-2" = "us-west-2",
    }
}

variable "rds_dns" {
}

variable "db_username" {
}

variable "tags" {
}

variable "ec2_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = "string"
  default     = ""
}

### Threshold Values

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = "string"
  default     = 80
}

variable "cpu_credit_balance_threshold" {
  description = "The minimum number of CPU credits (t2 instances only) available."
  type        = "string"
  default     = 20
}
variable "instance_dns" {
  
}

variable "env_name" {
  
}
