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
#   legacy_full_access: false          # (Optional) Also attach AmazonS3FullAccess, CloudWatchFullAccess and AmazonEC2ReadOnlyAccess
#                                     #   (account-wide access, not needed by the Beanstalk platform). Set false for least privilege. Default: false.
#   ecs_platform: true                # (Optional) Attach AWSElasticBeanstalkMulticontainerDocker; needed only on ECS-based Docker platform branches. Default: true.
#   s3_read_buckets: []               # (Optional) Extra bucket names the application may read (Get/List). Default: [].
#     - "my-app-assets"
#   s3_write_buckets: []              # (Optional) Extra bucket names the application may read, write and delete objects in. Default: [].
#     - "my-app-uploads"
# Always granted (scoped inline policy eb-instance-scoped): read on the three buckets this module creates
# (application versions, load balancer logs, default Elastic Beanstalk bucket), PutObject on the default
# Elastic Beanstalk bucket, CloudWatch agent logs on /aws/elasticbeanstalk/*, and ec2:DescribeTags/DescribeVolumes.
# Any other access must be granted through role_policies.
variable "instance_role" {
  description = "(Optional) Permission settings for the Elastic Beanstalk EC2 instance role; see the YAML comment above for attributes. Only extra S3 buckets are configurable; grant any other access through role_policies. Default: legacy_full_access = false, ecs_platform = true, no extra buckets."
  type = object({
    legacy_full_access = optional(bool, false)
    ecs_platform       = optional(bool, true)
    s3_read_buckets    = optional(list(string), [])
    s3_write_buckets   = optional(list(string), [])
  })
  default = {}
}

# role_policies:    # (Optional) Additional IAM policy ARNs attached to the EC2 instance role; the only way to grant
#                   #   access beyond the instance_role S3 bucket lists. Default: [].
#   - "arn:aws:iam::123456789012:policy/my-app-policy"
variable "role_policies" {
  description = "(Optional) List of additional IAM policy ARNs to attach to the Elastic Beanstalk EC2 instance role. Use this for any access beyond the instance_role S3 bucket lists. Default: []."
  type        = list(string)
  default     = []
}
