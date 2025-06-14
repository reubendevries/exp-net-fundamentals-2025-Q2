variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "Lab"
}

variable "tags" {
  description = "a map of our basic tags"
  type        = map(string)
  default = {
    "Project"     = "exp-net-fundatmentals"
    "ManagedBy"   = "terraform"
    "Environment" = "staging"
    "Region"      = "ca-central-1"
  }
}