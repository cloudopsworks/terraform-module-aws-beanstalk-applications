##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  iam_role_name = format("eb-ec2-role-%s", local.system_name)

  instance_role_log_group_arns = [
    for prefix in var.instance_role.log_group_prefixes :
    format("arn:aws:logs:%s:%s:log-group:%s*", data.aws_region.current.region, data.aws_caller_identity.current.account_id, prefix)
  ]
}

data "aws_iam_policy_document" "instance_role" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.instance_role.json
  tags               = local.all_tags
}

resource "aws_iam_instance_profile" "instance_role" {
  name = aws_iam_role.instance_role.name
  role = aws_iam_role.instance_role.id
  tags = local.all_tags
}

## Baseline managed policies required by the Elastic Beanstalk platform
resource "aws_iam_role_policy_attachment" "instance_role_attach_ssm" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "instance_role_attach_web" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "instance_role_attach_worker" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

## ECS-based Docker platform branches only
resource "aws_iam_role_policy_attachment" "instance_role_attach_docker" {
  count      = var.instance_role.ecs_platform ? 1 : 0
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

## Legacy broad managed policies (instance_role.legacy_full_access)
# Not needed by the Beanstalk platform: AWSElasticBeanstalkWebTier/WorkerTier and the scoped
# inline policy below cover it. Kept only for apps that still rely on account-wide access.
resource "aws_iam_role_policy_attachment" "instance_role_attach_ro" {
  count      = var.instance_role.legacy_full_access ? 1 : 0
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "instance_role_attach_s3full" {
  count      = var.instance_role.legacy_full_access ? 1 : 0
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "instance_role_attach_cw_full" {
  count      = var.instance_role.legacy_full_access ? 1 : 0
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

moved {
  from = aws_iam_role_policy_attachment.instance_role_attach_docker
  to   = aws_iam_role_policy_attachment.instance_role_attach_docker[0]
}

moved {
  from = aws_iam_role_policy_attachment.instance_role_attach_ro
  to   = aws_iam_role_policy_attachment.instance_role_attach_ro[0]
}

moved {
  from = aws_iam_role_policy_attachment.instance_role_attach_s3full
  to   = aws_iam_role_policy_attachment.instance_role_attach_s3full[0]
}

moved {
  from = aws_iam_role_policy_attachment.instance_role_attach_cw_full
  to   = aws_iam_role_policy_attachment.instance_role_attach_cw_full[0]
}

## Scoped least-privilege permissions
data "aws_iam_policy_document" "instance_role_scoped" {
  statement {
    sid     = "AppVersionsBucketRead"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:GetObjectVersion", "s3:ListBucket", "s3:GetBucketLocation"]
    resources = [
      module.versions_bucket.s3_bucket_arn,
      "${module.versions_bucket.s3_bucket_arn}/*",
    ]
  }

  dynamic "statement" {
    for_each = length(var.instance_role.s3_read_buckets) > 0 ? [1] : []
    content {
      sid     = "AppBucketsRead"
      effect  = "Allow"
      actions = ["s3:GetObject", "s3:GetObjectVersion", "s3:ListBucket", "s3:GetBucketLocation"]
      resources = flatten([
        for b in var.instance_role.s3_read_buckets : ["arn:aws:s3:::${b}", "arn:aws:s3:::${b}/*"]
      ])
    }
  }

  dynamic "statement" {
    for_each = length(var.instance_role.s3_write_buckets) > 0 ? [1] : []
    content {
      sid    = "AppBucketsReadWrite"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:GetBucketLocation",
      ]
      resources = flatten([
        for b in var.instance_role.s3_write_buckets : ["arn:aws:s3:::${b}", "arn:aws:s3:::${b}/*"]
      ])
    }
  }

  dynamic "statement" {
    for_each = length(local.instance_role_log_group_arns) > 0 ? [1] : []
    content {
      sid    = "CloudWatchAgentLogs"
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:PutRetentionPolicy",
        "logs:DescribeLogStreams",
      ]
      resources = local.instance_role_log_group_arns
    }
  }

  # ec2:DescribeTags / ec2:DescribeVolumes do not support resource-level permissions.
  statement {
    sid       = "CloudWatchAgentDescribe"
    effect    = "Allow"
    actions   = ["ec2:DescribeTags", "ec2:DescribeVolumes"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "instance_role_scoped" {
  name   = "eb-instance-scoped"
  role   = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.instance_role_scoped.json
}

## Extra customer-managed policies
resource "aws_iam_role_policy_attachment" "instance_role_attach_as_svc" {
  for_each   = toset(var.role_policies)
  role       = aws_iam_role.instance_role.name
  policy_arn = each.value
}
