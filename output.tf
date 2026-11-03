##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "iam_instance_role_id" {
  description = "Name (ID) of the IAM role assumed by Elastic Beanstalk EC2 instances."
  value       = aws_iam_role.instance_role.id
}

output "iam_instance_role_arn" {
  description = "ARN of the IAM role assumed by Elastic Beanstalk EC2 instances."
  value       = aws_iam_role.instance_role.arn
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile for Elastic Beanstalk EC2 instances."
  value       = aws_iam_instance_profile.instance_role.arn
}

output "iam_instance_profile_id" {
  description = "Name (ID) of the IAM instance profile for Elastic Beanstalk EC2 instances."
  value       = aws_iam_instance_profile.instance_role.id
}

output "iam_instance_profile_unique_id" {
  description = "Unique ID assigned by AWS to the IAM instance profile."
  value       = aws_iam_instance_profile.instance_role.unique_id
}

output "iam_service_role_id" {
  description = "Name (ID) of the Elastic Beanstalk service role."
  value       = aws_iam_role.service_role.id
}

output "iam_service_role_arn" {
  description = "ARN of the Elastic Beanstalk service role."
  value       = aws_iam_role.service_role.arn
}

output "applications" {
  description = "Map of created Elastic Beanstalk applications keyed by name, each with name and arn."
  value = {
    for item in var.applications : item => {
      name = item
      arn  = try(aws_elastic_beanstalk_application.this[item].arn, "")
    }
  }
}

output "logs_bucket_name" {
  description = "Name of the load balancer access logs S3 bucket."
  value       = module.logs_bucket.s3_bucket_id
}

output "versions_bucket_name" {
  description = "Name of the application versions S3 bucket."
  value       = module.versions_bucket.s3_bucket_id
}
