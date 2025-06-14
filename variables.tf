# AWS Variables
variable "aws_private_subnet_map" {
  description = "a map of all the private subnets we will be using in our aws networking"
  type        = map(string)
}

variable "aws_public_subnet_map" {
  description = "a map of all the public subnets we will be using in our aws networking"
  type        = map(string)
}

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "Lab"
}

variable "tags" {
  description = ""
  type        = map(string)
  default = {
    "Project"     = "exp-net-fundatmentals"
    "ManagedBy"   = "terraform"
    "Environment" = "staging"
    "Region"      = "ca-central-1"
  }
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}