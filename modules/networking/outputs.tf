output "hub_vnet_id" {
  description = "The resource ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "The name of the hub virtual network."
  value       = azurerm_virtual_network.hub.name
}

output "hub_vnet_resource_group_name" {
  description = "The name of the connectivity resource group."
  value       = azurerm_resource_group.connectivity.name
}

output "firewall_private_ip" {
  description = "The private IP address of the Azure Firewall."
  value       = var.enable_azure_firewall ? azurerm_firewall.hub[0].ip_configuration[0].private_ip_address : null
}

output "firewall_id" {
  description = "The resource ID of the Azure Firewall."
  value       = var.enable_azure_firewall ? azurerm_firewall.hub[0].id : null
}

output "vpn_gateway_id" {
  description = "The resource ID of the VPN Gateway."
  value       = var.enable_vpn_gateway ? azurerm_virtual_network_gateway.vpn[0].id : null
}

output "gateway_subnet_id" {
  description = "The resource ID of the GatewaySubnet."
  value       = azurerm_subnet.gateway.id
}

output "management_subnet_id" {
  description = "The resource ID of the management subnet."
  value       = azurerm_subnet.management.id
}
