## Example
```hcl
  module "subnets" {
    source                    = "../submodules/cidr-subnets"
    availability_zones        = var.availability_zones
    pod_base_cidr_block       = var.pod_base_cidr_block
    base_cidr_block           = var.base_cidr_block
    public_cidr_network_bits  = var.public_cidr_mask
    private_cidr_network_bits = var.private_cidr_mask
    subnet_name_prefix        = var.deploy_id
  }

  output "subnets" {
    value = module.subnets_cidr
  }
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_ids"></a> [availability\_zone\_ids](#input\_availability\_zone\_ids) | List of availability zones where the subnets will be created | `list(string)` | <pre>[<br>  "usw2-az1",<br>  "usw2-az2",<br>  "usw2-az3"<br>]</pre> | no |
| <a name="input_availability_zone_names"></a> [availability\_zone\_names](#input\_availability\_zone\_names) | List of availability zones where the subnets will be created | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_base_cidr_block"></a> [base\_cidr\_block](#input\_base\_cidr\_block) | CIDR block to serve the main private and public subnets | `string` | `"10.0.0.0/16"` | no |
| <a name="input_pod_base_cidr_block"></a> [pod\_base\_cidr\_block](#input\_pod\_base\_cidr\_block) | CIDR block to serve the pods subnets | `string` | `"100.164.0.0/16"` | no |
| <a name="input_pod_cidr_network_bits"></a> [pod\_cidr\_network\_bits](#input\_pod\_cidr\_network\_bits) | Number of network bits to allocate to the public subnet. i.e /18 -> 16,382 IPs | `number` | `18` | no |
| <a name="input_private_cidr_network_bits"></a> [private\_cidr\_network\_bits](#input\_private\_cidr\_network\_bits) | Number of network bits to allocate to the public subnet. i.e /19 -> 8,190 IPs | `number` | `19` | no |
| <a name="input_public_cidr_network_bits"></a> [public\_cidr\_network\_bits](#input\_public\_cidr\_network\_bits) | Number of network bits to allocate to the public subnet. i.e /27 -> 30 IPs | `number` | `27` | no |
| <a name="input_subnet_name_prefix"></a> [subnet\_name\_prefix](#input\_subnet\_name\_prefix) | String to serve as a prefix/identifier when naming the subnets | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pod_subnets"></a> [pod\_subnets](#output\_pod\_subnets) | Map containing the CIDR information for the pod subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Map containing the CIDR information for the private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Map containing the CIDR information for the public subnets |
<!-- END_TF_DOCS -->