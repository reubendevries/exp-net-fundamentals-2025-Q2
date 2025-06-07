aws_private_subnet_map = {
  "ca-central-1a" = "10.10.21.0/24"
  "ca-central-1b" = "10.10.22.0/24"
  "ca-central-1c" = "10.10.23.0/24"
}
aws_public_subnet_map = {
  "ca-central-1a" = "10.10.11.0/24"
  "ca-central-1b" = "10.10.12.0/24"
  "ca-central-1c" = "10.10.13.0/24"
}
environment_name    = "Lab"
tags = {
  "Owner"          = "ExamPro.co",
  "BoundedContext" = "Network Lab"
  "ManagedBy"      = "Terraform"
  "Environment"    = "Staging"
  "Region"         = "ca-central-1"
}
vpc_cidr = "10.0.0.0/16"