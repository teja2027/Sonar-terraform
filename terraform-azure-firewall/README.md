<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_application_rule_collection.application_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection) | resource |
| [azurerm_firewall_nat_rule_collection.nat_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection) | resource |
| [azurerm_firewall_network_rule_collection.network_rule_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection) | resource |
| [azurerm_firewall_policy.fw-policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.fw_rule_grp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_public_ip.firewall_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_monitor_diagnostic_categories.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |
| [azurerm_storage_account.storeacc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [terraform_remote_state.log_analytics](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_public_ips"></a> [additional\_public\_ips](#input\_additional\_public\_ips) | List of additional public ips' ids to attach to the firewall. | <pre>list(object({<br>    name                 = string,<br>    public_ip_address_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_application_rule_collections"></a> [application\_rule\_collections](#input\_application\_rule\_collections) | Create an application rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name             = string,<br>      source_addresses = list(string),<br>      source_ip_groups = list(string),<br>      target_fqdns     = list(string),<br>      protocols = list(object({<br>        port = string,<br>        type = string<br>      }))<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_create_firewall_policy"></a> [create\_firewall\_policy](#input\_create\_firewall\_policy) | n/a | `bool` | `false` | no |
| <a name="input_cross_subscription_law"></a> [cross\_subscription\_law](#input\_cross\_subscription\_law) | n/a | `bool` | `true` | no |
| <a name="input_deploy_log_workbook"></a> [deploy\_log\_workbook](#input\_deploy\_log\_workbook) | Deploy Azure Workbook Log in log analytics workspace. [GitHub Azure](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook) | `bool` | `true` | no |
| <a name="input_diagnostics_settings_name"></a> [diagnostics\_settings\_name](#input\_diagnostics\_settings\_name) | n/a | `string` | `"diag-test-vm"` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy. | `list(string)` | `null` | no |
| <a name="input_enable_diagnostics"></a> [enable\_diagnostics](#input\_enable\_diagnostics) | n/a | `bool` | `true` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | n/a | `string` | `"test-fw"` | no |
| <a name="input_firewall_policy_base_policy_id"></a> [firewall\_policy\_base\_policy\_id](#input\_firewall\_policy\_base\_policy\_id) | n/a | `string` | `null` | no |
| <a name="input_firewall_policy_dns"></a> [firewall\_policy\_dns](#input\_firewall\_policy\_dns) | n/a | `map(any)` | `{}` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | Attach an existing firewall policy to this firewall. Cannot be used in conjuction with `network_rule_collections`, `application_rule_collections` and `nat_rule_collections` variables. | `string` | `null` | no |
| <a name="input_firewall_policy_idps_mode"></a> [firewall\_policy\_idps\_mode](#input\_firewall\_policy\_idps\_mode) | In which mode you want to run intrusion detection: Off, Alert or Deny. | `string` | `"Off"` | no |
| <a name="input_firewall_policy_insights"></a> [firewall\_policy\_insights](#input\_firewall\_policy\_insights) | n/a | <pre>object({<br>    enabled                            = bool<br>    retention_in_days                  = optional(number)<br>    default_log_analytics_workspace_id = optional(string)<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_firewall_policy_name"></a> [firewall\_policy\_name](#input\_firewall\_policy\_name) | ----------------------------------- Azure Firewall Policy ----------------------------------- | `string` | `"test-fw-policy"` | no |
| <a name="input_firewall_policy_rule_collection_group"></a> [firewall\_policy\_rule\_collection\_group](#input\_firewall\_policy\_rule\_collection\_group) | n/a | <pre>map(object({<br>    name = string,<br>    priority = number,<br>    application_rule_collection = optional(list(object({<br>      name     = string,<br>      priority = number,<br>      action   = string,<br>      rule = list(object({<br>        name             = string,<br>        source_addresses = list(string),<br>        source_ip_groups = optional(list(string)),<br>        destination_fqdns     = optional(list(string)),<br>        destination_fqdn_tags = optional(list(string)),<br>        protocols = list(object({<br>            port = string,<br>            type = string<br>            }))<br>        }))<br>    })))<br><br>    network_rule_collection = optional(list(object({<br>        name     = string,<br>        priority = number,<br>        action   = string,<br>        rule = list(object({<br>          name                  = string,<br>          source_addresses      = optional(list(string)),<br>          source_ip_groups      = optional(list(string)),<br>          destination_ports     = list(string),<br>          destination_addresses = optional(list(string)),<br>          destination_ip_groups = optional(list(string)),<br>          destination_fqdns     = optional(list(string)),<br>          protocols             = list(string)<br>        }))<br>    })))<br><br>    nat_rule_collection = optional(list(object({<br>        name     = string,<br>        priority = number,<br>        action   = string,<br>        rule= list(object({<br>            name                  = string,<br>            source_addresses      = list(string),<br>            source_ip_groups      = list(string),<br>            destination_ports     = list(string),<br>            destination_addresses = list(string),<br>            translated_port       = number,<br>            translated_address    = string,<br>            protocols             = list(string)<br>            }))<br>        })))<br>    }))</pre> | `{}` | no |
| <a name="input_firewall_policy_sku"></a> [firewall\_policy\_sku](#input\_firewall\_policy\_sku) | The SKU Tier of the Firewall Policy. Possible values are Standard, Premium and Basic. | `string` | `"Premium"` | no |
| <a name="input_firewall_policy_threat_intelligence_allowlist"></a> [firewall\_policy\_threat\_intelligence\_allowlist](#input\_firewall\_policy\_threat\_intelligence\_allowlist) | n/a | `map(any)` | `{}` | no |
| <a name="input_firewall_policy_threat_intelligence_mode"></a> [firewall\_policy\_threat\_intelligence\_mode](#input\_firewall\_policy\_threat\_intelligence\_mode) | The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. | `string` | `"Alert"` | no |
| <a name="input_firewall_private_ip_ranges"></a> [firewall\_private\_ip\_ranges](#input\_firewall\_private\_ip\_ranges) | A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| <a name="input_firewall_zones"></a> [firewall\_zones](#input\_firewall\_zones) | Public IP zones to configure i.e. [1, 2, 3] | `list(string)` | `[]` | no |
| <a name="input_fw_ip_configuration_name"></a> [fw\_ip\_configuration\_name](#input\_fw\_ip\_configuration\_name) | n/a | `string` | `"test-fw-ipconfig"` | no |
| <a name="input_law_container_name"></a> [law\_container\_name](#input\_law\_container\_name) | n/a | `string` | `null` | no |
| <a name="input_law_resource_group_name"></a> [law\_resource\_group\_name](#input\_law\_resource\_group\_name) | n/a | `string` | `null` | no |
| <a name="input_law_state_key"></a> [law\_state\_key](#input\_law\_state\_key) | n/a | `string` | `null` | no |
| <a name="input_law_storage_account_name"></a> [law\_storage\_account\_name](#input\_law\_storage\_account\_name) | n/a | `string` | `null` | no |
| <a name="input_law_subscription_id"></a> [law\_subscription\_id](#input\_law\_subscription\_id) | n/a | `string` | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | n/a | `string` | `null` | no |
| <a name="input_log_categories"></a> [log\_categories](#input\_log\_categories) | n/a | `list` | `[]` | no |
| <a name="input_log_category_groups"></a> [log\_category\_groups](#input\_log\_category\_groups) | n/a | `list` | <pre>[<br>  "allLogs"<br>]</pre> | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | n/a | `list` | <pre>[<br>  "AllMetrics"<br>]</pre> | no |
| <a name="input_nat_rule_collections"></a> [nat\_rule\_collections](#input\_nat\_rule\_collections) | Create a Nat rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name                  = string,<br>      source_addresses      = list(string),<br>      source_ip_groups      = list(string),<br>      destination_ports     = list(string),<br>      destination_addresses = list(string),<br>      translated_port       = number,<br>      translated_address    = string,<br>      protocols             = list(string)<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_network_rule_collections"></a> [network\_rule\_collections](#input\_network\_rule\_collections) | Create a network rule collection | <pre>list(object({<br>    name     = string,<br>    priority = number,<br>    action   = string,<br>    rules = list(object({<br>      name                  = string,<br>      source_addresses      = list(string),<br>      source_ip_groups      = list(string),<br>      destination_ports     = list(string),<br>      destination_addresses = list(string),<br>      destination_ip_groups = list(string),<br>      destination_fqdns     = list(string),<br>      protocols             = list(string)<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic` | `string` | `"Static"` | no |
| <a name="input_public_ip_name"></a> [public\_ip\_name](#input\_public\_ip\_name) | n/a | `string` | `"test-pip"` | no |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | The SKU of the Public IP. Accepted values are `Basic` and `Standard` | `string` | `"Standard"` | no |
| <a name="input_public_ip_zones"></a> [public\_ip\_zones](#input\_public\_ip\_zones) | Public IP zones to configure i.e. [1, 2, 3] | `list(string)` | `[]` | no |
| <a name="input_retention_days"></a> [retention\_days](#input\_retention\_days) | n/a | `number` | `30` | no |
| <a name="input_signature_overrides_settings"></a> [signature\_overrides\_settings](#input\_signature\_overrides\_settings) | n/a | <pre>map(object({<br>    id    = optional(string)<br>    state = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | SKU tier of the Firewall. Possible values are `Premium` and `Standard` | `string` | `"Standard"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | RG name where the Storage account resides | `any` | `null` | no |
| <a name="input_storage_rg"></a> [storage\_rg](#input\_storage\_rg) | RG name where the Storage account resides | `any` | `null` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the firewall's subnet | `string` | `"AzureFirewallSubnet"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "Coxauto:ci-id": "CI2365171",<br>  "Coxauto:ssm:managed-patch-install-no-reboot": "No",<br>  "Coxauto:ssm:managed-patch-install-reboot": "Yes"<br>}</pre> | no |
| <a name="input_threat_intel_mode"></a> [threat\_intel\_mode](#input\_threat\_intel\_mode) | n/a | `string` | `"Off"` | no |
| <a name="input_traffic_bypass_settings"></a> [traffic\_bypass\_settings](#input\_traffic\_bypass\_settings) | n/a | <pre>map(object({<br>    name                  = string<br>    protocol              = string<br>    description           = optional(string)<br>    destination_addresses = optional(list(string))<br>    destination_ip_groups = optional(list(string))<br>    destination_ports     = optional(list(string))<br>    source_addresses      = optional(list(string))<br>    source_ip_groups      = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the vnet attached to the firewall. | `string` | n/a | yes |
| <a name="input_virtual_network_rg"></a> [virtual\_network\_rg](#input\_virtual\_network\_rg) | Name of the RG where VNET firewall resides. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | Firewall generated id |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | Firewall name |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Firewall private IP |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Firewall public IP |
<!-- END_TF_DOCS -->