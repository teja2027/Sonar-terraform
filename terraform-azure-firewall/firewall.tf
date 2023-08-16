data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_rg
}

data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_storage_account" "storeacc" {
  count               = var.storage_account_name != null ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.storage_rg
}

data "terraform_remote_state" "log_analytics" {
  count = var.cross_subscription_law && var.enable_diagnostics && var.log_analytics_workspace_id == null ? 1 : 0
  backend = "azurerm"

  config = {
    storage_account_name = var.law_storage_account_name
    container_name       = var.law_container_name
    key                  = var.law_state_key
    subscription_id      = var.law_subscription_id
    resource_group_name  = var.law_resource_group_name
  }
}

locals {
  firewall_policy_id = var.firewall_policy_id != null ? var.firewall_policy_id : azurerm_firewall_policy.fw-policy[0].id
}

resource "azurerm_public_ip" "firewall_public_ip" {
  name                = var.public_ip_name
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  zones               = var.public_ip_zones

  tags = var.tags
  
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      zones
    ]
  }
}

resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  zones               = var.firewall_zones
  threat_intel_mode   = var.threat_intel_mode
  
  ip_configuration {
    name                 = var.fw_ip_configuration_name
    subnet_id            = data.azurerm_subnet.snet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }

  dynamic "ip_configuration" {
    for_each = toset(var.additional_public_ips)
    content {
      name                 = lookup(ip_configuration.value, "name")
      public_ip_address_id = lookup(ip_configuration.value, "public_ip_address_id")
    }
  }

  private_ip_ranges  = var.firewall_private_ip_ranges
  firewall_policy_id = local.firewall_policy_id
  dns_servers        = var.dns_servers
  tags               = var.tags
  
  depends_on = [azurerm_firewall_policy.fw-policy]

  lifecycle {
    precondition {
      condition     = !(var.firewall_policy_id != null && (var.network_rule_collections != null || var.application_rule_collections != null || var.nat_rule_collections != null))
      error_message = "Do not use var.firewall_policy_id with var.network_rule_collections, var.application_rule_collections or var.nat_rule_collections variables. Migrate them into your policy."
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "network_rule_collection" {
  for_each = try({ for collection in var.network_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_addresses = rule.value.destination_addresses
      destination_ip_groups = rule.value.destination_ip_groups
      destination_fqdns     = rule.value.destination_fqdns
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "application_rule_collection" {
  for_each = try({ for collection in var.application_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      source_ip_groups = rule.value.source_ip_groups
      target_fqdns     = rule.value.target_fqdns
      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection" {
  for_each = try({ for collection in var.nat_rule_collections : collection.name => collection }, toset([]))

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
  priority            = each.value.priority
  action              = each.value.action
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
      protocols             = rule.value.protocols
    }
  }
}

#---------------------------------------------------------------
# Azure Firewall Policy
#---------------------------------------------------------------
resource "azurerm_firewall_policy" "fw-policy" {
  count                    = var.create_firewall_policy ? 1 : 0
  name                     = var.firewall_policy_name
  resource_group_name      = data.azurerm_virtual_network.vnet.resource_group_name
  location                 = data.azurerm_virtual_network.vnet.location
  sku                      = var.firewall_policy_sku
  base_policy_id           = var.firewall_policy_base_policy_id
  threat_intelligence_mode = var.firewall_policy_threat_intelligence_mode

  dynamic "dns" {
    for_each = var.firewall_policy_dns
    content {
      servers       = each.value.servers
      proxy_enabled = each.value.proxy_enabled
    }
  }
  dynamic "threat_intelligence_allowlist" {
    for_each = var.firewall_policy_threat_intelligence_allowlist
    content {
      ip_addresses = each.value.ip_addresses
      fqdns        = each.value.fqdns
    }
  }
  
  dynamic "insights" {
    for_each = var.firewall_policy_insights.enabled == true ? { "insights" = var.firewall_policy_insights } : {}
    content {
      enabled                            = insights.value.enabled
      default_log_analytics_workspace_id = insights.value.default_log_analytics_workspace_id
      retention_in_days                  = insights.value.retention_in_days
    }
  }

  intrusion_detection {
    mode = var.firewall_policy_idps_mode
    
    dynamic "traffic_bypass" {
    for_each = var.traffic_bypass_settings

      content {
        name = traffic_bypass.value.name
        protocol = traffic_bypass.value.protocol
        description = traffic_bypass.value.description

        destination_addresses = traffic_bypass.value.destination_addresses
        destination_ip_groups = traffic_bypass.value.destination_ip_groups
        destination_ports = traffic_bypass.value.destination_ports

        source_addresses = traffic_bypass.value.source_addresses
        source_ip_groups = traffic_bypass.value.source_ip_groups
      }
    }
    
    dynamic "signature_overrides" {
      for_each = var.signature_overrides_settings

      content {
        id    = signature_overrides.value.id
        state = signature_overrides.value.state
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "fw_rule_grp" {
  for_each = var.firewall_policy_rule_collection_group
  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.fw-policy.0.id
  priority           = each.value.priority
  dynamic "application_rule_collection" {
    for_each = each.value.application_rule_collection == null ? [] : each.value.application_rule_collection
    content {
        name     = application_rule_collection.value.name
        priority = application_rule_collection.value.priority
        action   = application_rule_collection.value.action

        dynamic "rule" {
          for_each = application_rule_collection.value.rule
          content {
            name = rule.value.name
            dynamic "protocols" {
                for_each = rule.value.protocols
                content {
                    type = protocols.value.type
                    port = protocols.value.port
                }
            }
            source_addresses  = rule.value.source_addresses
            destination_fqdns = rule.value.destination_fqdns
            destination_fqdn_tags = rule.value.destination_fqdn_tags
          }
        }
    }
  }

  dynamic "network_rule_collection" {
    for_each = each.value.network_rule_collection == null ? [] : each.value.network_rule_collection
    content {
        name     = network_rule_collection.value.name
        priority = network_rule_collection.value.priority
        action   = network_rule_collection.value.action
        dynamic "rule" {
          for_each = network_rule_collection.value.rules
          content {
            name                  = rule.value.name
            protocols             = rule.value.protocols
            source_addresses      = rule.value.source_addresses
            source_ip_groups      = rule.value.source_ip_groups
            destination_addresses = rule.value.destination_addresses
            destination_ports     = rule.value.destination_ports
            destination_ip_groups = rule.value.destination_ip_groups
            destination_fqdns     = rule.value.destination_fqdns
          }
        }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = each.value.nat_rule_collection == null ? [] : each.value.nat_rule_collection
    content {
        name     = nat_rule_collection.value.name
        priority = nat_rule_collection.value.priority
        action   = nat_rule_collection.value.action
        dynamic "rule" {
          for_each = nat_rule_collection.value.rule
          content {
            name                = rule.value.name
            protocols           = rule.value.protocols
            source_addresses    = rule.value.source_addresses
            destination_address = rule.value.destination_address
            # The `destination_ports` _must_ be a single port.
            destination_ports   = rule.value.destination_ports
            translated_address  = rule.value.translated_address
            translated_port     = rule.value.translated_port
          }
        }
    }
  }
}

#--------------------------------------------------------------
# Diagnostics Settings
#--------------------------------------------------------------
data "azurerm_monitor_diagnostic_categories" "this" {
  count       = var.enable_diagnostics ? 1 : 0
  resource_id = azurerm_firewall.firewall.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count                      = var.enable_diagnostics ? 1 : 0
  name                       = var.diagnostics_settings_name
  target_resource_id         = azurerm_firewall.firewall.id
  log_analytics_workspace_id = var.log_analytics_workspace_id != null ? var.log_analytics_workspace_id : (var.cross_subscription_law ? data.terraform_remote_state.log_analytics.0.outputs.log_analytics_resource_id : null)
  storage_account_id         = var.storage_account_name != null ? data.azurerm_storage_account.storeacc.0.id : null

  dynamic "enabled_log" {
    for_each = [ for x in toset(data.azurerm_monitor_diagnostic_categories.this.0.log_category_groups) : x if contains(var.log_category_groups, x) ]

    content {
      category_group = enabled_log.value

      retention_policy {
        enabled = true
        days    = var.retention_days
      }
    }
  }

  dynamic "enabled_log" {
    for_each = [ for x in toset(data.azurerm_monitor_diagnostic_categories.this.0.log_category_types) : x if contains(var.log_categories, x) ]

    content {
      category = enabled_log.value

      retention_policy {
        enabled = true
        days    = var.retention_days
      }
    }
  }

  dynamic "metric" {
    for_each = [ for x in toset(data.azurerm_monitor_diagnostic_categories.this.0.metrics) : x if contains(var.metrics, x) ]

    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.retention_days
      }
    }
  }

  lifecycle {
    ignore_changes = [metric]
  }
}
