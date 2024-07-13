##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "iam_instance_role_id" {
  value = aws_iam_role.instance_role.id
}

output "iam_instance_role_arn" {
  value = aws_iam_role.instance_role.arn
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.instance_role.arn
}

output "iam_instance_profile_id" {
  value = aws_iam_instance_profile.instance_role.id
}

output "iam_instance_profile_unique_id" {
  value = aws_iam_instance_profile.instance_role.unique_id
}

output "iam_service_role_id" {
  value = aws_iam_role.service_role.id
}

output "iam_service_role_arn" {
  value = aws_iam_role.service_role.arn
}

output "applications" {
  value = {
    for item in var.applications : item => {
      name = item
      arn  = aws_elastic_beanstalk_application.this[item].arn
    }
  }
}

output "logs_bucket_name" {
  value = module.logs_bucket.s3_bucket_id
}

output "versions_bucket_name" {
  value = module.versions_bucket.s3_bucket_id
}