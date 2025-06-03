variable "availability_zone" {
  description = "Availability Zone"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ca-central-1"
}

variable "environment_name" {
  description = "Name of the environment"
  type        = string
  default     = "Networking Fundatamental Bootcamp"
}

variable "private_subnet_cidr" {
  description = "CIDR for Private Subnet"
  type        = list(string)
  default     = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
}

variable "public_subnet_cidr" {
  description = "CIDR for Public Subnet"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
}

variable "tags" {
  description = ""
  type        = map(string)
  default = {
    "Owner"          = "ExamPro.co",
    "BoundedContext" = "Network Fundatmentals Bootcamp"
    "ManagedBy"      = "Terraform"
    "Environment"    = "Staging"
    "Region"         = "ca-central-1"
  }
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}