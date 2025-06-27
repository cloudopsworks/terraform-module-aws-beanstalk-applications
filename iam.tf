##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# Policy for ElasticBeanstalk assume role
data "aws_iam_policy_document" "service_role" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      values   = ["elasticbeanstalk"]
      variable = "sts:ExternalId"
    }
  }
}

# IAM Role for Elastic Beanstalk Service role
resource "aws_iam_role" "service_role" {
  name               = "eb-service-role-${local.system_name}"
  assume_role_policy = data.aws_iam_policy_document.service_role.json
  tags               = local.all_tags
}

resource "aws_iam_role_policy_attachment" "service_role_health" {
  role       = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "service_role_beanstalk" {
  role       = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}
