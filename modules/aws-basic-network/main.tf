resource "aws_vpc" "network_fundamentals_vpc" {
    cidr_block = local.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    assign_generated_ipv6_cidr_block = true
    instance_tenancy = "default"
    tags = merge({ "Name" = format("%s-vpc", local.environment_name)}, local.tags)
}

resource "aws_subnet" "public_subnet" {
    count = local.count
    vpc_id = aws_vpc.network_fundamentals_vpc.id
    cidr_block = local.public_subnet_cidr
    availability_zone = local.availability_zone
    tags = merge({ "Name" = format("%s-public-subnet", local.environment_name )}, local.tags)
}