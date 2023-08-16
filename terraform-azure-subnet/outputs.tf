output "subnet_ids" {
  value       = [for x in azurerm_subnet.snet : x.id]
  description = "ID of the Subnets"
}

output "subnet_name" {
  value = [for x in azurerm_subnet.snet : x.name] 
  description = "names of the subnets"
}

output "vnet_name" {
  description = "name of the vnet"
  value = data.azurerm_virtual_network.vnet.name
  
}

output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = data.azurerm_virtual_network.vnet.id
}
