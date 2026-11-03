##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# applications:     # (Required) Elastic Beanstalk application names to create.
#   - "my-api"
#   - "my-worker"
variable "applications" {
  description = "(Required) List of Elastic Beanstalk application names to create."
  type        = list(string)
}

# app_lifecycle:
#   delete_from_s3: false     # (Required) Delete the source bundle from S3 when a version is removed by the lifecycle policy.
#   max_count_versions: 200   # (Optional) Keep at most this many application versions. Default: null (no count limit).
#   max_age_retention: 180    # (Optional) Delete application versions older than this many days. Default: null (no age limit).
variable "app_lifecycle" {
  description = "(Optional) Application version lifecycle settings applied to every application; see the YAML comment above for attributes. Default: delete_from_s3 = false, no count or age limit."
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

# role_policies:    # (Optional) Additional IAM policy ARNs attached to the EC2 instance role. Default: [].
#   - "arn:aws:iam::123456789012:policy/my-app-policy"
variable "role_policies" {
  description = "(Optional) List of additional IAM policy ARNs to attach to the Elastic Beanstalk EC2 instance role. Default: []."
  type        = list(string)
  default     = []
}
