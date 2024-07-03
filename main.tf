##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_elastic_beanstalk_application" "this" {
  for_each    = toset(var.applications)
  name        = each.value
  description = "Elastic Beanstalk Application - ${each.value}"


  appversion_lifecycle {
    service_role          = aws_iam_role.service_role.arn
    max_count             = var.app_lifecycle.max_count_versions
    max_age_in_days       = var.app_lifecycle.max_age_retention
    delete_source_from_s3 = var.app_lifecycle.delete_from_s3
  }

  tags = merge({
    Name = each.value
  }, local.all_tags)
}