availability_zone   = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]
aws_region          = "ca-central-1"
environment_name    = "Networking Fundatamental Bootcamp"
private_subnet_cidr = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
public_subnet_cidr  = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
tags = {
  "Owner"          = "ExamPro.co",
  "BoundedContext" = "Network Fundatmentals Bootcamp"
  "ManagedBy"      = "Terraform"
  "Environment"    = "Staging"
  "Region"         = "ca-central-1"
}
vpc_cidr = "10.0.0.0/16"