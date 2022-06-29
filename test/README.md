<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnets"></a> [subnets](#module\_subnets) | ../submodules/cidr-subnets | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_base_cidr_block"></a> [base\_cidr\_block](#input\_base\_cidr\_block) | n/a | `string` | `"10.0.0.0/16"` | no |
| <a name="input_deploy_id"></a> [deploy\_id](#input\_deploy\_id) | Domino Deployment ID | `string` | `"mh-tf-eks-mod"` | no |
| <a name="input_pod_base_cidr_block"></a> [pod\_base\_cidr\_block](#input\_pod\_base\_cidr\_block) | n/a | `string` | `"100.164.0.0/16"` | no |
| <a name="input_pod_cidr_mask"></a> [pod\_cidr\_mask](#input\_pod\_cidr\_mask) | n/a | `number` | `27` | no |
| <a name="input_private_cidr_mask"></a> [private\_cidr\_mask](#input\_private\_cidr\_mask) | n/a | `number` | `19` | no |
| <a name="input_public_cidr_mask"></a> [public\_cidr\_mask](#input\_public\_cidr\_mask) | n/a | `number` | `27` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | n/a |
<!-- END_TF_DOCS -->