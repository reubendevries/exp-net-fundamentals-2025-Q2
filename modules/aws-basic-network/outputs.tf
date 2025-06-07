output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.network_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.network_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "Map of AZ to public subnet IDs"
  value       = { for az, subnet in aws_subnet.public_subnet : az => subnet.id }
}

output "private_subnet_ids" {
  description = "Map of AZ to private subnet IDs"
  value       = { for az, subnet in aws_subnet.private_subnet : az => subnet.id }
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.network_vpc.ipv6_cidr_block
}