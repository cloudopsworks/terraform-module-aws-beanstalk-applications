## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.35 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.35 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_beanstalk_bucket"></a> [beanstalk\_bucket](#module\_beanstalk\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 5.0 |
| <a name="module_logs_bucket"></a> [logs\_bucket](#module\_logs\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 5.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.10 |
| <a name="module_versions_bucket"></a> [versions\_bucket](#module\_versions\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 5.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_elastic_beanstalk_application.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application) | resource |
| [aws_iam_instance_profile.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_as_svc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_cw_full](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_docker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_s3full](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_role_attach_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.service_role_beanstalk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.service_role_health](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.beanstalk_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_app_lifecycle"></a> [app\_lifecycle](#input\_app\_lifecycle) | (Optional) Application version lifecycle settings applied to every application; see the YAML comment above for attributes. Default: delete\_from\_s3 = false, no count or age limit. | <pre>object({<br/>    delete_from_s3     = bool<br/>    max_count_versions = optional(number, null)<br/>    max_age_retention  = optional(number, null)<br/>  })</pre> | <pre>{<br/>  "delete_from_s3": false,<br/>  "max_age_retention": null,<br/>  "max_count_versions": null<br/>}</pre> | no |
| <a name="input_applications"></a> [applications](#input\_applications) | (Required) List of Elastic Beanstalk application names to create. | `list(string)` | n/a | yes |
| <a name="input_artifact_archive_days"></a> [artifact\_archive\_days](#input\_artifact\_archive\_days) | (Optional) Days before current artifacts in the application versions bucket transition to GLACIER. Must be greater than artifact\_transition\_days. Default: 365. | `number` | `365` | no |
| <a name="input_artifact_retention_years"></a> [artifact\_retention\_years](#input\_artifact\_retention\_years) | (Optional) Years before current artifacts in the application versions bucket expire (years * 365 days). Default: 3. | `number` | `3` | no |
| <a name="input_artifact_transition_days"></a> [artifact\_transition\_days](#input\_artifact\_transition\_days) | (Required) Days before current artifacts in the application versions bucket transition to STANDARD\_IA. | `number` | n/a | yes |
| <a name="input_default_bucket_prefix"></a> [default\_bucket\_prefix](#input\_default\_bucket\_prefix) | (Required) Prefix used in the logs and application versions bucket names. Must be 1-9 characters. | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_import_default_bucket"></a> [import\_default\_bucket](#input\_import\_default\_bucket) | (Optional) Import the pre-existing default Elastic Beanstalk bucket (elasticbeanstalk-<region>-<account\_id>) into state instead of creating it. Set to true when Elastic Beanstalk or a previous deployment already created the bucket. Default: false. | `bool` | `false` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_logs_archive_days"></a> [logs\_archive\_days](#input\_logs\_archive\_days) | (Required) Days before load balancer log objects transition to the GLACIER storage class. | `number` | n/a | yes |
| <a name="input_logs_retention_years"></a> [logs\_retention\_years](#input\_logs\_retention\_years) | (Optional) Years before load balancer log objects expire (converted to days as years * 365). Default: 3. | `number` | `3` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_random_bucket_suffix"></a> [random\_bucket\_suffix](#input\_random\_bucket\_suffix) | (Optional) Append an 8-character random suffix to the logs and application versions bucket names. Default: true. | `bool` | `true` | no |
| <a name="input_role_policies"></a> [role\_policies](#input\_role\_policies) | (Optional) List of additional IAM policy ARNs to attach to the Elastic Beanstalk EC2 instance role. Default: []. | `list(string)` | `[]` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_versions_archive_days"></a> [versions\_archive\_days](#input\_versions\_archive\_days) | (Optional) Days before noncurrent object versions in the application versions bucket transition to GLACIER. Default: 365. | `number` | `365` | no |
| <a name="input_versions_retention_years"></a> [versions\_retention\_years](#input\_versions\_retention\_years) | (Optional) Years before noncurrent object versions in the application versions bucket expire (years * 365 days). Default: 3. | `number` | `3` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_applications"></a> [applications](#output\_applications) | Map of created Elastic Beanstalk applications keyed by name, each with name and arn. |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | ARN of the IAM instance profile for Elastic Beanstalk EC2 instances. |
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | Name (ID) of the IAM instance profile for Elastic Beanstalk EC2 instances. |
| <a name="output_iam_instance_profile_unique_id"></a> [iam\_instance\_profile\_unique\_id](#output\_iam\_instance\_profile\_unique\_id) | Unique ID assigned by AWS to the IAM instance profile. |
| <a name="output_iam_instance_role_arn"></a> [iam\_instance\_role\_arn](#output\_iam\_instance\_role\_arn) | ARN of the IAM role assumed by Elastic Beanstalk EC2 instances. |
| <a name="output_iam_instance_role_id"></a> [iam\_instance\_role\_id](#output\_iam\_instance\_role\_id) | Name (ID) of the IAM role assumed by Elastic Beanstalk EC2 instances. |
| <a name="output_iam_service_role_arn"></a> [iam\_service\_role\_arn](#output\_iam\_service\_role\_arn) | ARN of the Elastic Beanstalk service role. |
| <a name="output_iam_service_role_id"></a> [iam\_service\_role\_id](#output\_iam\_service\_role\_id) | Name (ID) of the Elastic Beanstalk service role. |
| <a name="output_logs_bucket_name"></a> [logs\_bucket\_name](#output\_logs\_bucket\_name) | Name of the load balancer access logs S3 bucket. |
| <a name="output_versions_bucket_name"></a> [versions\_bucket\_name](#output\_versions\_bucket\_name) | Name of the application versions S3 bucket. |
