locals {
  aws_region       = var.aws_region
  environment_name = var.environment_name
  private_subnets = {
    "${var.availability_zone[0]}" = var.private_subnet_cidr[0]
    "${var.availability_zone[1]}" = var.private_subnet_cidr[1]
    "${var.availability_zone[2]}" = var.private_subnet_cidr[2]
  }
  public_subnets = {
    "${var.availability_zone[0]}" = var.public_subnet_cidr[0]
    "${var.availability_zone[1]}" = var.public_subnet_cidr[1]
    "${var.availability_zone[2]}" = var.public_subnet_cidr[2]
  }
  tags     = var.tags
  vpc_cidr = var.vpc_cidr
}