<!-- BEGIN_TF_DOCS -->
## Inframodules/aws-basic-network/README.md updated successfully
modules/aws-setup-iam-role/README.md updated successfully
" {
  # source
  source = "./modules/aws-basic-network"
  # variables
  aws_private_subnet_map = var.aws_private_subnet_map
  aws_public_subnet_map  = var.aws_public_subnet_map
  environment_name       = var.environment_name
  vpc_cidr               = var.vpc_cidr
}

module "aws_setup_iam_role" {
  # source
  source = "./modules/aws-setup-iam-role"
  # inputs
  environment_name = var.environment_name
  tags             = var.tags
}
# AWS Variables
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
  description = "The tags we'll be enfocring on our resources."
  type        = map(string)
  default = {
    "Owner"          = "ExamPro.co",
    "BoundedContext" = "Network Lab"
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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.99.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_basic_network"></a> [aws\_basic\_network](#module\_aws\_basic\_network) | ./modules/aws-basic-network | n/a |
| <a name="module_aws_setup_iam_role"></a> [aws\_setup\_iam\_role](#module\_aws\_setup\_iam\_role) | ./modules/aws-setup-iam-role | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_private_subnet_map"></a> [aws\_private\_subnet\_map](#input\_aws\_private\_subnet\_map) | a map of all the private subnets we will be using in our aws networking | `map(string)` | n/a | yes |
| <a name="input_aws_public_subnet_map"></a> [aws\_public\_subnet\_map](#input\_aws\_public\_subnet\_map) | a map of all the public subnets we will be using in our aws networking | `map(string)` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of the environment | `string` | `"Lab"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags we'll be enfocring on our resources. | `map(string)` | <pre>{<br/>  "BoundedContext": "Network Lab",<br/>  "Environment": "Staging",<br/>  "ManagedBy": "Terraform",<br/>  "Owner": "ExamPro.co",<br/>  "Region": "ca-central-1"<br/>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.

<!-- END_TF_DOCS -->