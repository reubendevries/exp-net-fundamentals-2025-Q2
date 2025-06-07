resource "aws_vpc" "network_vpc" {
  cidr_block                       = local.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"
  tags                             = merge({ "Name" = format("%s-vpc", local.environment_name) }, local.tags)
}

resource "aws_subnet" "public_subnet" {
  for_each = local.aws_public_subnet_map

  vpc_id                  = aws_vpc.network_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge({
    "Name" = format("%s-%s-public-subnet", local.environment_name, each.key)
  }, local.tags)
}

resource "aws_subnet" "private_subnet" {
  for_each = local.aws_private_subnet_map

  vpc_id            = aws_vpc.network_vpc.id
  cidr_block        = each.value
  availability_zone = each.key
	map_public_ip_on_launch = false

  tags = merge({
    "Name" = format("%s-%s-private-subnet", local.environment_name, each.key)
  }, local.tags)
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.network_vpc.id
  tags   = merge({ "Name" = format("%s-igw", local.environment_name) }, local.tags)
}

resource "aws_eip" "elastic_ip" {
	for_each = local.aws_public_subnet_map

	tags = merge({ "Name" = format("%s-%s-nat-ip", local.environment_name, each.key) }, local.tags)
	
	depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway" {
	for_each = local.aws_public_subnet_map

	subnet_id = aws_subnet.public_subnet[each.key].id
	allocation_id = aws_eip.elastic_ip[each.key].id
	tags = merge({ "Name" = format("%s-%s-nat-gw", local.environment_name, each.key) }, local.tags)
	
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.network_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge({ "Name" = format("%s-public-route-table", local.environment_name) }, local.tags)
}

resource "aws_route_table" "private_route_table" {
	for_each = local.aws_private_subnet_map

  vpc_id = aws_vpc.network_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.key].id
  }

  tags = merge({ "Name" = format("%s-%s-private-route-table", local.environment_name, each.key) }, local.tags)
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each = local.aws_public_subnet_map

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each = local.aws_private_subnet_map

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id
}