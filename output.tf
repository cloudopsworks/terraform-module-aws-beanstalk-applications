##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "iam_instance_role_name" {
  value = aws_iam_role.instance_role.name
}

output "iam_instance_role_arn" {
  value = aws_iam_role.instance_role.arn
}

output "iam_service_role_name" {
  value = aws_iam_role.service_role.name
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