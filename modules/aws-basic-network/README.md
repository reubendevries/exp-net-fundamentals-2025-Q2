<!-- BEGIN_TF_DOCS -->
## Infrastructure Diagram
![Infrastructure Diagram](infrastructure-diagram.png)

## Usage

```hcl
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
variable "availability_zone" {
  description = "Availability Zone"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ca-central-1"
}

variable "environment_name" {
  description = "Name of the environment"
  type        = string
  default     = "Networking Fundatamental Bootcamp"
}

variable "private_subnet_cidr" {
  description = "CIDR for Private Subnet"
  type        = list(string)
  default     = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
}

variable "public_subnet_cidr" {
  description = "CIDR for Public Subnet"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
}

variable "tags" {
  description = ""
  type        = map(string)
  default = {
    "Owner"          = "ExamPro.co",
    "BoundedContext" = "Network Fundatmentals Bootcamp"
    "ManagedBy"      = "Terraform"
    "Environment"    = "Staging"
    "Region"         = "ca-central-1"
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
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.network_fundamentals_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability Zone | `list(string)` | <pre>[<br/>  "ca-central-1a",<br/>  "ca-central-1b",<br/>  "ca-central-1c"<br/>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"ca-central-1"` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of the environment | `string` | `"Networking Fundatamental Bootcamp"` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | CIDR for Private Subnet | `list(string)` | <pre>[<br/>  "10.10.21.0/24",<br/>  "10.10.22.0/24",<br/>  "10.10.23.0/24"<br/>]</pre> | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | CIDR for Public Subnet | `list(string)` | <pre>[<br/>  "10.10.11.0/24",<br/>  "10.10.12.0/24",<br/>  "10.10.13.0/24"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br/>  "BoundedContext": "Network Fundatmentals Bootcamp",<br/>  "Environment": "Staging",<br/>  "ManagedBy": "Terraform",<br/>  "Owner": "ExamPro.co",<br/>  "Region": "ca-central-1"<br/>}</pre> | no |
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