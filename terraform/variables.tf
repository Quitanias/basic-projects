############## General ###############
variable "region" {
  description = "The AWS Region"
  type        = string
}

############### EC2 ##################
variable "instance_type" {
  description = "The AWS EC2 instance type"
  type        = string
  default     = "t2.micro"
}

############### RDS (module) ##################
variable "db_name" {
  description = "Database name for RDS module"
  type        = string
  default     = "mydb"
}
