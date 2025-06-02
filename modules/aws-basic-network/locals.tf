locals {
    availability_zone = var.availability_zone
    aws_region = var.aws_region
    count = 3 // for high availability
    environment_name = var.environment_name
    private_subnet_cidr = var.private_subnet_cidr
    public_subnet_cidr = var.public_subnet_cidr
    tags = var.tags
    vpc_cidr = var.vpc_cidr
}