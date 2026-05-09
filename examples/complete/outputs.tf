output "root_management_group_id" {
  description = "The ID of the root management group."
  value       = module.platform_landing_zone.root_management_group_id
}

output "hub_vnet_id" {
  description = "The resource ID of the hub VNet."
  value       = module.platform_landing_zone.hub_vnet_id
}

output "log_analytics_workspace_id" {
  description = "The workspace ID of the Log Analytics workspace."
  value       = module.platform_landing_zone.log_analytics_workspace_id
}
