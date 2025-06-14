variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "Lab"
}

variable "tags" {
  description = ""
  type        = map(string)
  default = {
    "Project"     = "Network Fundamentals Lab"
    "ManagedBy"   = "Terraform"
    "Environment" = "Staging"
    "Region"      = "ca-central-1"
  }
}