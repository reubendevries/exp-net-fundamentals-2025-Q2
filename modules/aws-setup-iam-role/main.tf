resource "aws_iam_policy" "tf_bucket_state_policy" {
  name = "${local.environment}-tf-bucket-state-policy"
  policy = templatefile("${path.module}/templates/tf_bucket_state_policy.json.tftpl", {
    bucket_name = local.bucket_name
  })
  tags = merge(
    {
      "Name" = format(
        "%s-tf-bucket-state-policy", local.environment
      )
      "Role" = "Deploy Role"
    },
    local.tags
  )
}

resource "aws_iam_policy" "ec2_creation_tagging_policy" {
  name = "${local.environment}-ec2-creation-tagging-policy"
  policy = templatefile("${path.module}/templates/ec2_creation_tagging_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-ec2=creation-tagging-policy", local.environment
      )
      "Role" = "Deploy Role"
    },
    local.tags
  )
}

resource "aws_iam_policy" "ec2_delete_read_policy" {
  name = "${local.environment}-ec2-delete-read-policy"
  policy = templatefile("${path.module}/templates/ec2_delete_read_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-ec2-delete-read-policy", local.environment
      )
      "Role" = "Deploy Role"
    },
    local.tags
  )
}

resource "aws_iam_policy" "ec2_management_update_policy" {
  name = "${local.environment}-ec2-management-update-policy"
  policy = templatefile("${path.module}/templates/ec2_management_update_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format(
        "%s-ec2-management-update-policy", local.environment
      )
      "Role" = "Deploy Role"
    },
    local.tags
  )
}

resource "aws_iam_policy" "vpc_flow_logs_role_retrieval_policy" {
  name = "${local.environment}-vpc-flow-logs-role-retrieval-policy"
  policy = templatefile("${path.module}/templates/vpc_flow_logs_role_retrieval_policy.json.tftpl", {
    account_id  = local.account_id,
    environment = local.environment
  })
  tags = merge(
    {
      "Name" = format(
        "%s-vpc-flow-logs-role-retrieval-policy", local.environment
      )
      "Role" = "Deploy Role"
    },
    local.tags
  )
}

resource "aws_iam_policy" "vpc_flow_log_policy" {
  name = "${local.environment}-vpc-flow-log-policy"
  policy = templatefile("${path.module}/templates/vpc_flow_log_policy.json.tftpl", {
    account_id = local.account_id,
    region     = local.region
  })
  tags = merge(
    {
      "Name" = format("%s-vpc-flow-log-policy", local.environment)
      "Role" = "VPC Flow Logs"
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
      "Role" = "Deploy Role"
    },
    local.tags
  )
}

resource "aws_iam_role" "vpc_flow_log_role" {
  name               = format("%s-vpc-flow-log-role", local.environment)
  path               = "/"
  description        = "IAM role for VPC Flow Logs"
  assume_role_policy = templatefile("${path.module}/templates/vpc_flow_log_assume_role_policy.json.tftpl", {})
  tags = merge(
    {
      "Name" = format("%s-vpc-flow-log-role", local.environment)
      "Role" = "VPC Flow Logs"
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