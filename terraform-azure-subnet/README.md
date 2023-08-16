<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.bastion_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.fw-snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.gw_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_service_endpoints"></a> [bastion\_service\_endpoints](#input\_bastion\_service\_endpoints) | n/a | `set(string)` | `null` | no |
| <a name="input_bastion_subnet_address_prefix"></a> [bastion\_subnet\_address\_prefix](#input\_bastion\_subnet\_address\_prefix) | CIDR block/Address space for the Gateway Subnet | `list(string)` | `null` | no |
| <a name="input_firewall_service_endpoints"></a> [firewall\_service\_endpoints](#input\_firewall\_service\_endpoints) | n/a | `set(string)` | `null` | no |
| <a name="input_firewall_subnet_address_prefix"></a> [firewall\_subnet\_address\_prefix](#input\_firewall\_subnet\_address\_prefix) | CIDR block/Address space for the Firewall Subnet | `list(string)` | `null` | no |
| <a name="input_gateway_service_endpoints"></a> [gateway\_service\_endpoints](#input\_gateway\_service\_endpoints) | n/a | `set(string)` | `null` | no |
| <a name="input_gateway_subnet_address_prefix"></a> [gateway\_subnet\_address\_prefix](#input\_gateway\_subnet\_address\_prefix) | CIDR block/Address space for the Gateway Subnet | `list(string)` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Details of the subnet like name and address prefix | <pre>map(object({<br>    name = string<br>    address_prefixes = list(string)<br>    service_endpoints = optional(list(string))<br>    service_endpoint_policy_ids = optional(list(string))<br>    private_endpoint_network_policies_enabled = optional(bool)<br>    private_link_service_network_policies_enabled = optional(bool)<br>    delegation = optional(object({<br>      name = string<br>      service_delegation = object({<br>        name = string<br>        actions = list(string)<br>      })<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the VNET to be created | `string` | `null` | no |
| <a name="input_virtual_network_rg"></a> [virtual\_network\_rg](#input\_virtual\_network\_rg) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | ID of the Subnets |
<!-- END_TF_DOCS -->