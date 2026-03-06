############## General ###############
variable "region" {
  description = "The AWS Region"
  type        = string
}

############### Vault ################
variable "access_key" {
  description = "The Vault access key"
  type        = string
}

variable "secret_key" {
  description = "The Vault secret key"
  type        = string
}

############### EC2 ##################
variable "instance_type" {
  description = "The AWS EC2 instance type"
  type        = string
  default     = "t2.micro"
}
