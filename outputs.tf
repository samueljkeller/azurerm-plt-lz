output "root_management_group_id" {
  description = "The ID of the root management group."
  value       = module.management_groups.root_management_group_id
}

output "platform_management_group_id" {
  description = "The ID of the Platform management group."
  value       = module.management_groups.platform_management_group_id
}

output "landing_zones_management_group_id" {
  description = "The ID of the Landing Zones management group."
  value       = module.management_groups.landing_zones_management_group_id
}

output "log_analytics_workspace_id" {
  description = "The workspace ID of the central Log Analytics workspace."
  value       = module.management.log_analytics_workspace_id
}

output "log_analytics_workspace_resource_id" {
  description = "The resource ID of the central Log Analytics workspace."
  value       = module.management.log_analytics_workspace_resource_id
}

output "hub_vnet_id" {
  description = "The resource ID of the hub virtual network."
  value       = module.networking.hub_vnet_id
}

output "hub_vnet_name" {
  description = "The name of the hub virtual network."
  value       = module.networking.hub_vnet_name
}

output "firewall_private_ip" {
  description = "The private IP address of the Azure Firewall (if enabled)."
  value       = module.networking.firewall_private_ip
}

output "vpn_gateway_id" {
  description = "The resource ID of the VPN Gateway (if enabled)."
  value       = module.networking.vpn_gateway_id
}
