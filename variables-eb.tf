##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "applications" {
  description = "List of Elastic Beanstalk applications"
  type        = list(string)
}

variable "app_lifecycle" {
  description = "Lifecycle of versions for Applications"
  type = object({
    delete_from_s3     = bool
    max_count_versions = optional(number, null)
    max_age_retention  = optional(number, null)
  })
  default = {
    delete_from_s3     = false
    max_count_versions = null
    max_age_retention  = null
  }
}
