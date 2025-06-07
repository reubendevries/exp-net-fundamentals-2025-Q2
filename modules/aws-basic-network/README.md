<!-- BEGIN_TF_DOCS -->
## Infrastructure Diagram
![Infrastructure Diagram](infrastructure-diagram.png)

## Usage

```hcl
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

  vpc_id                  = aws_vpc.network_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
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

  subnet_id     = aws_subnet.public_subnet[each.key].id
  allocation_id = aws_eip.elastic_ip[each.key].id
  tags          = merge({ "Name" = format("%s-%s-nat-gw", local.environment_name, each.key) }, local.tags)

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
    cidr_block     = "0.0.0.0/0"
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
variable "aws_private_subnet_map" {
  description = "a map of all the private subnets we will be using in our aws networking"
  type        = map(string)
}

variable "aws_public_subnet_map" {
  description = "a map of all the public subnets we will be using in our aws networking"
  type        = map(string)
}

variable "environment_name" {
  description = "Name of the environment"
  type        = string
  default     = "Lab"
}

variable "tags" {
  description = ""
  type        = map(string)
  default = {
    "Project"     = "Network Fundamentals Lab"
    "ManagedBy"   = "Terraform"
    "Environment" = "Staging"
    "Region"      = "ca-central-1"
  }
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.elastic_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.network_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_private_subnet_map"></a> [aws\_private\_subnet\_map](#input\_aws\_private\_subnet\_map) | a map of all the private subnets we will be using in our aws networking | `map(string)` | n/a | yes |
| <a name="input_aws_public_subnet_map"></a> [aws\_public\_subnet\_map](#input\_aws\_public\_subnet\_map) | a map of all the public subnets we will be using in our aws networking | `map(string)` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of the environment | `string` | `"Lab"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br/>  "Environment": "Staging",<br/>  "ManagedBy": "Terraform",<br/>  "Project": "Network Fundamentals Lab",<br/>  "Region": "ca-central-1"<br/>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Map of AZ to private subnet IDs |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Map of AZ to public subnet IDs |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_ipv6_cidr_block"></a> [vpc\_ipv6\_cidr\_block](#output\_vpc\_ipv6\_cidr\_block) | The IPv6 CIDR block of the VPC |

<!-- END_TF_DOCS -->