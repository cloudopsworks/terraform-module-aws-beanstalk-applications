##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
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

# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "service_role" {
  name               = "eb-service-role-${local.system_name}"
  assume_role_policy = data.aws_iam_policy_document.service_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkService"
  ]
  tags               = local.all_tags
}
