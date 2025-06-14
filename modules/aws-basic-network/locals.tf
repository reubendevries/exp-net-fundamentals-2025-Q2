data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


locals {
  aws_region             = data.aws_region.current.name
  environment            = var.environment
  aws_private_subnet_map = var.aws_private_subnet_map
  aws_public_subnet_map  = var.aws_public_subnet_map
  tags                   = var.tags
  vpc_cidr               = var.vpc_cidr
}

data "aws_iam_role" "vpc_flow_log_role" {
  name = "${local.environment}-vpc-flow-log-role"
}