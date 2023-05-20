variable "prefix" {
  description = "Name prefix for resources."
  type        = string
}

#cluster
variable "cluster_identifier" {
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
  type        = string
}
variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage."
  type        = string
  default     = "5.0.0"
}
variable "master_username" {
  description = "Username for the master DB user."
  type        = string
}
variable "port" {
  description = "The port on which the DB accepts connections."
  type        = number
  default     = 27017
}
variable "backup_retention_period" {
  description = "The days to retain backups for."
  type        = number
  default     = 1
}
variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.Time in UTC Default: A 30-minute window selected at random from an 8-hour block of time per region."
  type        = string
  default     = "07:00-07:30"

  validation {
    condition     = can(regex("^[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]$", var.preferred_backup_window))
    error_message = "The specified format is invalid. Syntax: \"hh24:mi-hh24:mi\""
  }
}
variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}
variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, profiler."
  type        = list(string)
  default     = ["audit", "profiler"]

  validation {
    condition = alltrue([
      for e in var.enabled_cloudwatch_logs_exports : contains(["audit", "profiler"], e)
    ])
    error_message = "The enabled_cloudwatch_logs_exports supports audit or profiler."
  }
}
variable "preferred_maintenance_window" {
  # https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-maintain.html#maintenance-window
  description = "The weekly time range during which system maintenance can occur, in (UTC) e.g., wed:04:00-wed:04:30"
  type        = string
  default     = "wed:04:00-wed:04:30"

  validation {
    condition     = can(regex("^(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]-(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]$", var.preferred_maintenance_window))
    error_message = "The specified format is invalid. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\""
  }
}
variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted."
  type        = bool
  default     = false
}
variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted."
  type        = bool
  default     = false
}

# instance
variable "instance_count" {
  description = "The number of DB instances."
  type        = number
}
variable "instance_identifier" {
  description = "The identifier for the DocumentDB instance."
  type        = string
}
# https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-classes-by-region
variable "instance_class" {
  description = "The instance class to use."
  type        = string
  default     = "db.t4g.medium"
}
variable "enable_performance_insights" {
  description = "A value that indicates whether to enable Performance Insights for the DB Instance."
  type        = bool
  default     = false
}

# parameter group
variable "use_custom_parameter_group" {
  description = "A cluster parameter group to associate with the cluster."
  type        = bool
  default     = false
}
variable "parameter_group_family" {
  description = "The family of the DocumentDB cluster parameter group."
  type        = string
}
variable "parameter_group_parameter_overrides_immediately" {
  description = "Map of parameters to override default values."
  type        = map(string)
}
variable "parameter_group_parameter_overrides_on_reboot" {
  description = "Map of parameters to override default values."
  type        = map(string)
}

# db subnet
variable "vpc_id" {
  description = "ID of the VPC to associate with these DB instances."
  type        = string
}
variable "private_subnet_ids" {
  description = "List of the subnet IDs to associate with these DB instances."
  type        = list(string)
}
