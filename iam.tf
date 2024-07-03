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

data "aws_iam_policy" "enhanced_health" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

data "aws_iam_policy" "beanstalk_service" {
  arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkService"
}

# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "service_role" {
  name               = "eb-service-role-${local.system_name}"
  assume_role_policy = data.aws_iam_policy_document.service_role.json
  tags               = local.all_tags
}

resource "aws_iam_role_policy_attachment" "enhanced_health" {
  policy_arn = data.aws_iam_policy.enhanced_health.arn
  role       = aws_iam_role.service_role.name
}

resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  policy_arn = data.aws_iam_policy.beanstalk_service.arn
  role       = aws_iam_role.service_role.name
}