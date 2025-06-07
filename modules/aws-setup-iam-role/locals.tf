data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id       = data.aws_caller_identity.current.account_id
  bucket_name      = "rd2025-exp-net-fundamentals-2025-q2"
  environment_name = var.environment_name
  region           = data.aws_region.current.name
  tags             = var.tags
}