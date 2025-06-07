<!-- BEGIN_TF_DOCS -->
## Infrastructure Diagram
![Infrastructure Diagram](infrastructure-diagram.png)

## Usage

```hcl
resource "aws_iam_policy" "bucket_state_policy" {
  policy = templatefile("${path.module}/templates/bucket_state_policy.json.tftpl", {
    bucket_name = local.bucket_name
  })
  tags = merge(
    {
      "Name" = format(
        "%s-bucket-state-policy", local.environment_name
      )
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_policy" "create_policy" {
  policy = templatefile("${path.module}/templates/create_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-create-policy", local.environment_name
      )
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_policy" "delete_policy" {
  policy = templatefile("${path.module}/templates/delete_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-delete-policy", local.environment_name
      )
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_policy" "read_policy" {
  policy = templatefile("${path.module}/templates/read_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-read-policy", local.environment_name
      )
      "Role" = "Deployer"
    },
    local.tags
  )
}

resource "aws_iam_policy" "update_policy" {
  policy = templatefile("${path.module}/templates/update_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-update-policy", local.environment_name
      )
      "Role" = "Deploy Role"
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

resource "aws_iam_role_policy_attachment" "bucket_state_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.bucket_state_policy.arn
}

resource "aws_iam_role_policy_attachment" "create_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.create_policy.arn
}

resource "aws_iam_role_policy_attachment" "delete_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.delete_policy.arn
}

resource "aws_iam_role_policy_attachment" "read_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.read_policy.arn
}

resource "aws_iam_role_policy_attachment" "update_policy_attachment" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = aws_iam_policy.update_policy.arn
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
| [aws_iam_policy.bucket_state_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.create_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.delete_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.update_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.deployer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bucket_state_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.create_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.delete_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.update_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
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