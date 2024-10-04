## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logs_bucket"></a> [logs\_bucket](#module\_logs\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.1.2 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |
| <a name="module_versions_bucket"></a> [versions\_bucket](#module\_versions\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_elastic_beanstalk_application.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application) | resource |
| [aws_iam_instance_profile.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_lifecycle"></a> [app\_lifecycle](#input\_app\_lifecycle) | Lifecycle of versions for Applications | <pre>object({<br/>    delete_from_s3     = bool<br/>    max_count_versions = optional(number, null)<br/>    max_age_retention  = optional(number, null)<br/>  })</pre> | <pre>{<br/>  "delete_from_s3": false,<br/>  "max_age_retention": null,<br/>  "max_count_versions": null<br/>}</pre> | no |
| <a name="input_applications"></a> [applications](#input\_applications) | List of Elastic Beanstalk applications | `list(string)` | n/a | yes |
| <a name="input_artifact_archive_days"></a> [artifact\_archive\_days](#input\_artifact\_archive\_days) | (required) Transition to archive storage tier Standard-IA -> Glacier in days. | `number` | `365` | no |
| <a name="input_artifact_retention_years"></a> [artifact\_retention\_years](#input\_artifact\_retention\_years) | (required) Versions bucket last artifact available deletion policy | `number` | `3` | no |
| <a name="input_artifact_transition_days"></a> [artifact\_transition\_days](#input\_artifact\_transition\_days) | (required) Versions bucket transition to different tiers Day 0 -> Standard-IA -> Glacier in days. | `number` | n/a | yes |
| <a name="input_default_bucket_prefix"></a> [default\_bucket\_prefix](#input\_default\_bucket\_prefix) | Default prefix for the bucket name | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_logs_archive_days"></a> [logs\_archive\_days](#input\_logs\_archive\_days) | (required) Log bucket file archiving to GLACIER time policy | `number` | n/a | yes |
| <a name="input_logs_retention_years"></a> [logs\_retention\_years](#input\_logs\_retention\_years) | (required) Log bucket expiration time policy in years. | `number` | `3` | no |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_random_bucket_suffix"></a> [random\_bucket\_suffix](#input\_random\_bucket\_suffix) | Add a random suffix to the bucket name | `bool` | `true` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |
| <a name="input_versions_archive_days"></a> [versions\_archive\_days](#input\_versions\_archive\_days) | (required) Transition to archive storage tier Standard-IA -> Glacier in days. | `number` | `365` | no |
| <a name="input_versions_retention_years"></a> [versions\_retention\_years](#input\_versions\_retention\_years) | (required) Versions bucket artifact versions deletion policy | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_applications"></a> [applications](#output\_applications) | n/a |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | n/a |
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | n/a |
| <a name="output_iam_instance_profile_unique_id"></a> [iam\_instance\_profile\_unique\_id](#output\_iam\_instance\_profile\_unique\_id) | n/a |
| <a name="output_iam_instance_role_arn"></a> [iam\_instance\_role\_arn](#output\_iam\_instance\_role\_arn) | n/a |
| <a name="output_iam_instance_role_id"></a> [iam\_instance\_role\_id](#output\_iam\_instance\_role\_id) | n/a |
| <a name="output_iam_service_role_arn"></a> [iam\_service\_role\_arn](#output\_iam\_service\_role\_arn) | n/a |
| <a name="output_iam_service_role_id"></a> [iam\_service\_role\_id](#output\_iam\_service\_role\_id) | n/a |
| <a name="output_logs_bucket_name"></a> [logs\_bucket\_name](#output\_logs\_bucket\_name) | n/a |
| <a name="output_versions_bucket_name"></a> [versions\_bucket\_name](#output\_versions\_bucket\_name) | n/a |
