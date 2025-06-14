<!-- BEGIN_TF_DOCS -->
## Infrastructure Diagram
![Infrastructure Diagram](infrastructure-diagram.png)

## Usage

```hcl
resource "aws_iam_policy" "tf_bucket_state_policy" {
  name = "${local.environment_name}-tf-bucket-state-policy"
  policy = templatefile("${path.module}/templates/tf_bucket_state_policy.json.tftpl", {
    bucket_name = local.bucket_name
  })
  tags = merge(
    {
      "Name" = format(
        "%s-tf-bucket-state-policy", local.environment_name
      )
      "Role" = "Terraform State Managment"
    },
    local.tags
  )
}

resource "aws_iam_policy" "ec2_creation_tagging_policy" {
  name = "${local.environment_name}-ec2-creation-tagging-policy"
  policy = templatefile("${path.module}/templates/ec2_creation_tagging_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-ec2=creation-tagging-policy", local.environment_name
      )
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_policy" "ec2_delete_read_policy" {
  name = "${local.environment_name}-ec2-delete-read-policy"
  policy = templatefile("${path.module}/templates/ec2_delete_read_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-ec2-delete-read-policy", local.environment_name
      )
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_policy" "ec2_management_update_policy" {
  name = "${local.environment_name}-ec2-management-update-policy"
  policy = templatefile("${path.module}/templates/ec2_management_update_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-ec2-management-update-policy", local.environment_name
      )
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_policy" "vpc_flow_logs_role_retrieval_policy" {
  name = "${local.environment_name}-vpc-flow-logs-role-retrieval-policy"
  policy = templatefile("${path.module}/templates/vpc_flow_logs_role_retrieval_policy.json.tftpl", {
    account_id = local.account_id
  })
  tags = merge(
    {
      "Name" = format(
        "%s-vpc-flow-logs-role-retrieval-policy", local.environment_name
      )
      "Role" = "Deploy Role"
    },
    local.tags
  )
}

resource "aws_iam_policy" "vpc_flow_log_policy" {
  name = "${local.environment_name}-vpc-flow-log-policy"
  policy = templatefile("${path.module}/templates/vpc_flow_log_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format("%s-vpc-flow-log-policy", local.environment_name)
      "Role" = "Flow Logs"
    },
    local.tags
  )
}

resource "aws_iam_role" "deployer_role" {
  name        = "exp-net-fundamentals-deploy-gha-role"
  path        = "/"
  description = "IAM role for Deployment"

  assume_role_policy = templatefile("${path.module}/templates/github_actions_trust_policy.json.tftpl", {
    account_id = local.account_id,
  })
  max_session_duration  = 3600
  force_detach_policies = true
  tags = merge(
    {
      "Name" = "exp-net-fundamentals-deploy-gha-role"
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_role" "vpc_flow_log_role" {
  name               = format("%s-vpc-flow-log-role", local.environment_name)
  path               = "/"
  description        = "IAM role for VPC Flow Logs"
  assume_role_policy = templatefile("${path.module}/templates/vpc_flow_log_assume_role_policy.json.tftpl", {})
  tags = merge(
    {
      "Name" = format("%s-vpc-flow-log-role", local.environment_name)
      "Role" = "Flow Logs"
    },
    local.tags
  )
}

resource "aws_iam_role_policy_attachment" "tf_bucket_state_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.tf_bucket_state_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_creation_tagging_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.ec2_creation_tagging_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_delete_read_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.ec2_delete_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_management_update_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.ec2_management_update_policy.arn
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs_role_retrieval_policy" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.vpc_flow_logs_role_retrieval_policy.arn
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_policy_attachment" {
  role       = aws_iam_role.vpc_flow_log_role.name
  policy_arn = aws_iam_policy.vpc_flow_log_policy.arn
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
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.ec2_creation_tagging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ec2_delete_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ec2_management_update_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tf_bucket_state_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vpc_flow_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vpc_flow_logs_role_retrieval_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.deployer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.vpc_flow_log_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_creation_tagging_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_delete_read_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_management_update_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tf_bucket_state_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc_flow_log_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc_flow_logs_role_retrieval_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of the environment | `string` | `"Lab"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br/>  "Environment": "Staging",<br/>  "ManagedBy": "Terraform",<br/>  "Project": "Network Fundamentals Lab",<br/>  "Region": "ca-central-1"<br/>}</pre> | no |

## Outputs

No outputs.

<!-- END_TF_DOCS -->