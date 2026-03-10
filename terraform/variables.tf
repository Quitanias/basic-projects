############## General ###############
variable "region" {
  description = "The AWS Region"
  type        = string
}

variable "availability_zone" {
  description = "The AWS Availability Zone"
  type        = string
}

variable "env" {
  description = "The environment to develop"
  type        = map(string)
  default = {
    "dev"  = "dev"
    "prod" = "prod"
  }
}

############### EC2 ##################
variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The AWS EC2 instance type"
  type        = string
}

variable "volume_size" {
  description = "The size of the EBS volume in GB"
  type        = number
}

variable "volume_type" {
  description = "The type of the EBS volume"
  type        = string
}

############### RDS (module) ##################
variable "db_name" {
  description = "Database name for RDS module"
  type        = string
}
