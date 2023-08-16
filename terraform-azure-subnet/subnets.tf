data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_rg
}

resource "azurerm_subnet" "snet" {
  for_each                                      = var.subnets
  name                                          = each.value["name"]
  resource_group_name                           = var.virtual_network_rg
  virtual_network_name                          = var.virtual_network_name
  address_prefixes                              = each.value["address_prefixes"]
  service_endpoints                             = lookup(each.value, "service_endpoints", [])
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", null)
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", false)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", false)

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }
}

resource "azurerm_subnet" "fw-snet" {
  count                = var.firewall_subnet_address_prefix != null ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.virtual_network_rg
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.firewall_subnet_address_prefix
  service_endpoints    = var.firewall_service_endpoints
}

resource "azurerm_subnet" "gw_snet" {
  count                = var.gateway_subnet_address_prefix != null ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = var.virtual_network_rg
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.gateway_subnet_address_prefix
  service_endpoints    = var.gateway_service_endpoints
}

resource "azurerm_subnet" "bastion_snet" {
  count                = var.bastion_subnet_address_prefix != null ? 1 : 0
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.virtual_network_rg
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.bastion_subnet_address_prefix
  service_endpoints    = var.bastion_service_endpoints
}
