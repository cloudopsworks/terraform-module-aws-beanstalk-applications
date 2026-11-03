##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## Bucket naming
# random_bucket_suffix: true   # (Optional) Append an 8-char random suffix to bucket names. Default: true.
# default_bucket_prefix: "app" # (Required) Bucket name prefix, 1-9 characters.
# Resulting bucket names:
#   logs-<default_bucket_prefix>-<system_name_short>[-<random>]
#   appver-<default_bucket_prefix>-<system_name_short>-<random>
#   elasticbeanstalk-<region>-<account_id>
variable "random_bucket_suffix" {
  description = "(Optional) Append an 8-character random suffix to the logs and application versions bucket names. Default: true."
  type        = bool
  default     = true
}

variable "default_bucket_prefix" {
  description = "(Required) Prefix used in the logs and application versions bucket names. Must be 1-9 characters."
  type        = string
  validation {
    condition     = length(var.default_bucket_prefix) > 0 && length(var.default_bucket_prefix) < 10
    error_message = "The default bucket prefix must be between 1 and 10 characters"
  }

}

## Load balancer logs bucket lifecycle
# logs_archive_days: 90      # (Required) Days before log objects transition to GLACIER.
# logs_retention_years: 3    # (Optional) Years before log objects expire. Default: 3.
variable "logs_retention_years" {
  type        = number
  description = "(Optional) Years before load balancer log objects expire (converted to days as years * 365). Default: 3."
  default     = 3
}

variable "logs_archive_days" {
  type        = number
  description = "(Required) Days before load balancer log objects transition to the GLACIER storage class."
}

## Application versions bucket lifecycle
# artifact_transition_days: 30  # (Required) Days before current artifacts move to STANDARD_IA.
# artifact_archive_days: 365    # (Optional) Days before current artifacts move to GLACIER. Default: 365.
# artifact_retention_years: 3   # (Optional) Years before current artifacts expire. Default: 3.
# versions_archive_days: 365    # (Optional) Days before noncurrent versions move to GLACIER. Default: 365.
# versions_retention_years: 3   # (Optional) Years before noncurrent versions expire. Default: 3.
variable "versions_retention_years" {
  type        = number
  description = "(Optional) Years before noncurrent object versions in the application versions bucket expire (years * 365 days). Default: 3."
  default     = 3
}

variable "artifact_retention_years" {
  type        = number
  description = "(Optional) Years before current artifacts in the application versions bucket expire (years * 365 days). Default: 3."
  default     = 3
}

variable "artifact_transition_days" {
  type        = number
  description = "(Required) Days before current artifacts in the application versions bucket transition to STANDARD_IA."
}

variable "artifact_archive_days" {
  type        = number
  description = "(Optional) Days before current artifacts in the application versions bucket transition to GLACIER. Must be greater than artifact_transition_days. Default: 365."
  default     = 365
}

variable "versions_archive_days" {
  type        = number
  description = "(Optional) Days before noncurrent object versions in the application versions bucket transition to GLACIER. Default: 365."
  default     = 365
}

## Default Elastic Beanstalk bucket
# import_default_bucket: false  # (Optional) Adopt an existing elasticbeanstalk-<region>-<account_id> bucket. Default: false.
variable "import_default_bucket" {
  type        = bool
  description = "(Optional) Import the pre-existing default Elastic Beanstalk bucket (elasticbeanstalk-<region>-<account_id>) into state instead of creating it. Set to true when Elastic Beanstalk or a previous deployment already created the bucket. Default: false."
  default     = false
}
