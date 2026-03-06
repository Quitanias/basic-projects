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

variable "username" {
  description = "Master username for the DB"
  type        = string
}

variable "password" {
  description = "Master password for the DB"
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
