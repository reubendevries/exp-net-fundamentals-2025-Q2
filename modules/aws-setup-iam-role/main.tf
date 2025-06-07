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

resource "aws_iam_policy" "vpc_flow_log_policy" {
  name   = "${local.environment_name}-vpc-flow-log-policy"
  policy = templatefile("${path.module}/templates/vpc_flow_log_policy.json.tftpl")
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
  assume_role_policy = templatefile("${path.module}/templates/vpc_flow_log_trust_policy.json.tftpl")
  tags = merge(
    {
      "Name" = format("%s-vpc-flow-log-role", local.environment_name)
      "Role" = "Flow Logs"
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

resource "aws_iam_role_policy_attachment" "vpc_flow_log_policy_attachment" {
  role       = aws_iam_role.vpc_flow_log_role.name
  policy_arn = aws_iam_policy.vpc_flow_log_policy.arn
}