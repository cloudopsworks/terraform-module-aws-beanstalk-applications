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

# instance_role:
#   legacy_full_access: true          # (Optional) Also attach AmazonS3FullAccess, CloudWatchFullAccess and AmazonEC2ReadOnlyAccess
#                                     #   (account-wide access, not needed by the Beanstalk platform). Set false for least privilege. Default: true.
#   ecs_platform: true                # (Optional) Attach AWSElasticBeanstalkMulticontainerDocker; needed only on ECS-based Docker platform branches. Default: true.
#   s3_read_buckets: []               # (Optional) Extra bucket names the application may read (Get/List). Default: [].
#     - "my-app-assets"
#   s3_write_buckets: []              # (Optional) Extra bucket names the application may read, write and delete objects in. Default: [].
#     - "my-app-uploads"
#   log_group_prefixes:               # (Optional) Log group name prefixes the CloudWatch agent may create and write to. Default: ["/aws/elasticbeanstalk/"].
#     - "/aws/elasticbeanstalk/"
# Always granted (scoped inline policy eb-instance-scoped): read on the application versions bucket,
# CloudWatch agent logs on log_group_prefixes, and ec2:DescribeTags/DescribeVolumes.
variable "instance_role" {
  description = "(Optional) Permission settings for the Elastic Beanstalk EC2 instance role; see the YAML comment above for attributes. Default: legacy_full_access = true, ecs_platform = true, no extra buckets, log_group_prefixes = [\"/aws/elasticbeanstalk/\"]."
  type = object({
    legacy_full_access = optional(bool, true)
    ecs_platform       = optional(bool, true)
    s3_read_buckets    = optional(list(string), [])
    s3_write_buckets   = optional(list(string), [])
    log_group_prefixes = optional(list(string), ["/aws/elasticbeanstalk/"])
  })
  default = {}
  validation {
    condition     = alltrue([for p in var.instance_role.log_group_prefixes : startswith(p, "/")])
    error_message = "instance_role.log_group_prefixes entries must start with '/' (e.g. /aws/elasticbeanstalk/)."
  }
}

# role_policies:    # (Optional) Additional IAM policy ARNs attached to the EC2 instance role. Default: [].
#   - "arn:aws:iam::123456789012:policy/my-app-policy"
variable "role_policies" {
  description = "(Optional) List of additional IAM policy ARNs to attach to the Elastic Beanstalk EC2 instance role. Default: []."
  type        = list(string)
  default     = []
}
