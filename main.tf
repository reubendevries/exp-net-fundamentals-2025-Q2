module "aws_basic_network" {
  # source
  source = "./modules/aws-basic-network"
  # variables
  aws_private_subnet_map = var.aws_private_subnet_map
  aws_public_subnet_map  = var.aws_public_subnet_map
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
}

module "aws_setup_iam_role" {
  # source
  source = "./modules/aws-setup-iam-role"
  # inputs
  environment = var.environment
  tags        = var.tags
}