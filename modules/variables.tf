############### RDS ##################
variable "allocated_storage" {
  description = "Allocated storage size (GB) for the DB instance"
  type        = number
  default     = 10
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "Instance class for the DB"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username for the DB"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "Parameter group name for the DB"
  type        = string
  default     = "default.mysql8.0"
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "replication_source_identifier" {
  description = "ARN of the source DB instance for replication"
  type        = string
  default     = null
}

variable "password_wo" {
  description = "Master password for the DB (without version)"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "password_wo_version" {
  description = "Version of the master password for the DB"
  type        = number
}