variable "alarm_emails" {
    type = "list"
}
variable "regions" {
    type = "map"
    # default = {
    #     "east-1" = "us-east-1",
    #     "east-2" = "us-east-2",
    #     "west-1" = "us-west-1",
    #     "west-2" = "us-west-2",
    # }
}

variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = "string"
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

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = "string"
  default     = 64
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = "string"
  default     = 64000000

  # 64 Megabyte in Byte
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = "string"
  default     = 2000000000

  # 2 Gigabyte in Byte
}
