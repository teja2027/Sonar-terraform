variable "virtual_network_name" {
  description = "Name of the vnet attached to the firewall."
  type        = string
}

variable "virtual_network_rg" {
  description = "Name of the RG where VNET firewall resides."
  type        = string
}

variable "subnet_name" {
  description = "Name of the firewall's subnet"
  type        = string
  default     = "AzureFirewallSubnet"
}

variable "log_analytics_workspace_id" {
  type = string
  default  = null
}

variable "storage_rg" {
  description = "RG name where the Storage account resides"
  default     = null
}

variable "storage_account_name" {
  description = "RG name where the Storage account resides"
  default     = null
}

variable "create_firewall_policy" {
  default = false
}

variable "public_ip_name" {
  default = "test-pip"
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic`"
  default     = "Static"
}

variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are `Basic` and `Standard`"
  default     = "Standard"
}

variable "public_ip_zones" {
  description = "Public IP zones to configure i.e. [1, 2, 3]"
  type        = list(string)
  default     = []
}

variable "firewall_zones" {
  description = "Public IP zones to configure i.e. [1, 2, 3]"
  type        = list(string)
  default     = []
}

variable "firewall_name" {
  default = "test-fw"
}

variable "threat_intel_mode" {
  default = "Off"
}

variable "fw_ip_configuration_name" {
  default = "test-fw-ipconfig"
}

variable "firewall_private_ip_ranges" {
  description = "A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "network_rule_collections" {
  description = "Create a network rule collection"
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name                  = string,
      source_addresses      = list(string),
      source_ip_groups      = list(string),
      destination_ports     = list(string),
      destination_addresses = list(string),
      destination_ip_groups = list(string),
      destination_fqdns     = list(string),
      protocols             = list(string)
    }))
  }))
  default = null
}

variable "application_rule_collections" {
  description = "Create an application rule collection"
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name             = string,
      source_addresses = list(string),
      source_ip_groups = list(string),
      target_fqdns     = list(string),
      protocols = list(object({
        port = string,
        type = string
      }))
    }))
  }))
  default = null
}

variable "nat_rule_collections" {
  description = "Create a Nat rule collection"
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name                  = string,
      source_addresses      = list(string),
      source_ip_groups      = list(string),
      destination_ports     = list(string),
      destination_addresses = list(string),
      translated_port       = number,
      translated_address    = string,
      protocols             = list(string)
    }))
  }))
  default = null
}

variable "firewall_policy_rule_collection_group" {
  default = {}
  type = map(object({
    name = string,
    priority = number,
    application_rule_collection = optional(list(object({
      name     = string,
      priority = number,
      action   = string,
      rule = list(object({
        name             = string,
        source_addresses = list(string),
        source_ip_groups = optional(list(string)),
        destination_fqdns     = optional(list(string)),
        destination_fqdn_tags = optional(list(string)),
        protocols = list(object({
            port = string,
            type = string
            }))
        }))
    })))

    network_rule_collection = optional(list(object({
        name     = string,
        priority = number,
        action   = string,
        rule = list(object({
          name                  = string,
          source_addresses      = optional(list(string)),
          source_ip_groups      = optional(list(string)),
          destination_ports     = list(string),
          destination_addresses = optional(list(string)),
          destination_ip_groups = optional(list(string)),
          destination_fqdns     = optional(list(string)),
          protocols             = list(string)
        }))
    })))

    nat_rule_collection = optional(list(object({
        name     = string,
        priority = number,
        action   = string,
        rule= list(object({
            name                  = string,
            source_addresses      = list(string),
            source_ip_groups      = list(string),
            destination_ports     = list(string),
            destination_addresses = list(string),
            translated_port       = number,
            translated_address    = string,
            protocols             = list(string)
            }))
        })))
    }))
}

variable "dns_servers" {
  description = "DNS Servers to use with Azure Firewall. Using this also activate DNS Proxy."
  type        = list(string)
  default     = null
}

variable "additional_public_ips" {
  description = "List of additional public ips' ids to attach to the firewall."
  type = list(object({
    name                 = string,
    public_ip_address_id = string
  }))
  default = []
}

variable "deploy_log_workbook" {
  description = "Deploy Azure Workbook Log in log analytics workspace. [GitHub Azure](https://github.com/Azure/Azure-Network-Security/tree/master/Azure%20Firewall/Workbook%20-%20Azure%20Firewall%20Monitor%20Workbook)"
  type        = bool
  default     = true
}

variable "sku_tier" {
  description = "SKU tier of the Firewall. Possible values are `Premium` and `Standard`"
  type        = string
  default     = "Standard"
}

variable "firewall_policy_id" {
  description = "Attach an existing firewall policy to this firewall. Cannot be used in conjuction with `network_rule_collections`, `application_rule_collections` and `nat_rule_collections` variables."
  type        = string
  default     = null
}

variable "tags" {
  type = map(any)
  default = {
    "Coxauto:ci-id"                               = "CI2365171"
    "Coxauto:ssm:managed-patch-install-reboot"    = "Yes"
    "Coxauto:ssm:managed-patch-install-no-reboot" = "No"
  }
}

#-----------------------------------
# Azure Firewall Policy
#-----------------------------------
variable "firewall_policy_name" {
  type = string
  default = "test-fw-policy"
}

variable "firewall_policy_sku" {
  description = "The SKU Tier of the Firewall Policy. Possible values are Standard, Premium and Basic."
  default = "Premium"
}

variable "firewall_policy_base_policy_id" {
  type = string
  default = null
}

variable "firewall_policy_threat_intelligence_mode" {
  description = "The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off."
  default = "Alert"
}

variable "firewall_policy_dns" {
  type = map(any)
  default = {}
}

variable "firewall_policy_threat_intelligence_allowlist" {
  type = map(any)
  default = {} 
}

variable "firewall_policy_idps_mode" {
  default = "Off"
  description = "In which mode you want to run intrusion detection: Off, Alert or Deny."
}

variable "firewall_policy_insights" {
  type = object({
    enabled                            = bool
    retention_in_days                  = optional(number)
    default_log_analytics_workspace_id = optional(string)
  })
  default = {
    enabled = false
  }
}

variable "traffic_bypass_settings" {
  type = map(object({
    name                  = string
    protocol              = string
    description           = optional(string)
    destination_addresses = optional(list(string))
    destination_ip_groups = optional(list(string))
    destination_ports     = optional(list(string))
    source_addresses      = optional(list(string))
    source_ip_groups      = optional(list(string))
  }))
  default = {}
#   example = {
#     bypass1 = {
#       name                  = "Bypass 1"
#       protocol              = "ANY"
#       description           = "Bypass traffic setting 1"
#       destination_addresses = ["192.168.1.1", "192.168.1.2"]
#       destination_ports     = ["80", "443"]
#     },
#     bypass2 = {
#       name                  = "Bypass 2"
#       protocol              = "TCP"
#       description           = "Bypass traffic setting 2"
#       destination_addresses = ["10.0.0.1"]
#       source_addresses      = ["192.168.2.0/24"]
#     },
#   }
}

variable "signature_overrides_settings" {
  type = map(object({
    id    = optional(string)
    state = optional(string)
  }))
  
  default = {}
#   example = {
#     override1 = {
#       id    = "123456789012"
#       state = "Alert"
#     },
#     override2 = {
#       id    = "987654321098"
#       state = "Deny"
#     },
#   }
}


variable "log_categories" {
  default = []
  # Different log categories that we can enable for Firewall:
      # "AZFWApplicationRule"
      # "AZFWApplicationRuleAggregation"
      # "AZFWDnsQuery"
      # "AZFWFatFlow"
      # "AZFWFlowTrace"
      # "AZFWFqdnResolveFailure"
      # "AZFWIdpsSignature"
      # "AZFWNatRule"
      # "AZFWNatRuleAggregation"
      # "AZFWNetworkRule"
      # "AZFWNetworkRuleAggregation"
      # "AZFWThreatIntel"
      # "AzureFirewallApplicationRule"
      # "AzureFirewallDnsProxy"
      # "AzureFirewallNetworkRule"
}

variable "log_category_groups" {
  default = ["allLogs"]
}

variable "metrics" {
  default = ["AllMetrics"]
}

variable "retention_days" {
  default = 30
}

variable "enable_diagnostics" {
  default = true
}

variable "diagnostics_settings_name" {
  default = "diag-test-vm"
}

variable "cross_subscription_law" {
  default = true
}

variable "law_subscription_id" {
  type = string
  default  = null
}

variable "law_resource_group_name" {
  type = string
  default  = null
}

variable "law_storage_account_name" {
  type = string
  default  = null
}

variable "law_container_name" {
  type = string
  default  = null
}

variable "law_state_key" {
  type = string
  default  = null
}
