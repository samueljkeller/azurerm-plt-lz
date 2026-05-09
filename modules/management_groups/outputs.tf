output "root_management_group_id" {
  description = "The ID of the root management group."
  value       = azurerm_management_group.root.id
}

output "platform_management_group_id" {
  description = "The ID of the Platform management group."
  value       = azurerm_management_group.platform.id
}

output "connectivity_management_group_id" {
  description = "The ID of the Connectivity management group."
  value       = azurerm_management_group.connectivity.id
}

output "identity_management_group_id" {
  description = "The ID of the Identity management group."
  value       = azurerm_management_group.identity.id
}

output "management_management_group_id" {
  description = "The ID of the Management management group."
  value       = azurerm_management_group.management.id
}

output "landing_zones_management_group_id" {
  description = "The ID of the Landing Zones management group."
  value       = azurerm_management_group.landing_zones.id
}

output "landing_zone_management_group_ids" {
  description = "Map of landing zone management group IDs."
  value       = { for k, v in azurerm_management_group.landing_zone : k => v.id }
}
