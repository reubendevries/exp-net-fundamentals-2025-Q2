resource "aws_vpc" "network_fundamentals_vpc" {
  cidr_block                       = local.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"
  tags                             = merge({ "Name" = format("%s VPC", local.environment_name) }, local.tags)
}

resource "aws_subnet" "public_subnet" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.network_fundamentals_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge({
    "Name" = format("%s Public Subnet - %s", local.environment_name, each.key)
  }, local.tags)
}

resource "aws_subnet" "private_subnet" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.network_fundamentals_vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge({
    "Name" = format("%s Private Subnet - %s", local.environment_name, each.key)
  }, local.tags)
}