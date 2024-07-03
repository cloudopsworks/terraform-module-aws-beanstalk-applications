##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

# Policy for ElasticBeanstalk assume role
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

# IAM Role for Elastic Beanstalk Instances
resource "aws_iam_role" "instance_role" {
  name               = "eb-ec2-role-${local.system_name}"
  assume_role_policy = data.aws_iam_policy_document.instance_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  ]
  tags               = local.all_tags
}

resource "aws_iam_instance_profile" "instance_role" {
  name = aws_iam_role.instance_role.name
  role = aws_iam_role.instance_role.id
  tags = local.all_tags
}
