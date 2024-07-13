##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "random_bucket_suffix" {
  description = "Add a random suffix to the bucket name"
  type        = bool
  default     = true
}

variable "default_bucket_prefix" {
  description = "Default prefix for the bucket name"
  type        = string
  validation {
    condition     = length(var.default_bucket_prefix) > 0 && length(var.default_bucket_prefix) < 10
    error_message = "The default bucket prefix must be between 1 and 10 characters"
  }

}

variable "logs_retention_years" {
  type        = number
  description = "(required) Log bucket expiration time policy in years."
  default     = 3
}

variable "logs_archive_days" {
  type        = number
  description = "(required) Log bucket file archiving to GLACIER time policy"
}

variable "versions_retention_years" {
  type        = number
  description = "(required) Versions bucket artifact versions deletion policy"
  default     = 3
}

variable "artifact_retention_years" {
  type        = number
  description = "(required) Versions bucket last artifact available deletion policy"
  default     = 3
}

variable "artifact_transition_days" {
  type        = number
  description = "(required) Versions bucket transition to different tiers Day 0 -> Standard-IA -> Glacier in days."
}

variable "artifact_archive_days" {
  type        = number
  description = "(required) Transition to archive storage tier Standard-IA -> Glacier in days."
  default     = 365
}

variable "versions_archive_days" {
  type        = number
  description = "(required) Transition to archive storage tier Standard-IA -> Glacier in days."
  default     = 365
}