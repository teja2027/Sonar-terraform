variable "subnets" {
  type = map(object({
    name = string
    address_prefixes = list(string)
    service_endpoints = optional(list(string))
    service_endpoint_policy_ids = optional(list(string))
    private_endpoint_network_policies_enabled = optional(bool)
    private_link_service_network_policies_enabled = optional(bool)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name = string
        actions = list(string)
      })
    }))
  }))
  default     = null
  description = "Details of the subnet like name and address prefix"
}

variable "virtual_network_name" {
  description = "Name of the VNET to be created"
  type = string
  default = null
}

variable "virtual_network_rg" {
  type = string
  default = null
}

variable "firewall_subnet_address_prefix" {
  description = "CIDR block/Address space for the Firewall Subnet"
  type = list(string)
  default     = null
}

variable "firewall_service_endpoints" {
  type = set(string)
  default     = null
}

variable "gateway_subnet_address_prefix" {
  description = "CIDR block/Address space for the Gateway Subnet"
  type = list(string)
  default     = null
}

variable "gateway_service_endpoints" {
  type = set(string)
  default     = null
}

variable "bastion_subnet_address_prefix" {
  description = "CIDR block/Address space for the Gateway Subnet"
  type = list(string)
  default     = null
}

variable "bastion_service_endpoints" {
  type = set(string)
  default = null
}
