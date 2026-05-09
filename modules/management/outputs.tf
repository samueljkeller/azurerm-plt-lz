output "log_analytics_workspace_id" {
  description = "The workspace ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.management.workspace_id
}

output "log_analytics_workspace_resource_id" {
  description = "The resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.management.id
}

output "automation_account_id" {
  description = "The resource ID of the Automation Account."
  value       = azurerm_automation_account.management.id
}

output "management_resource_group_name" {
  description = "The name of the management resource group."
  value       = azurerm_resource_group.management.name
}

output "action_group_id" {
  description = "The resource ID of the critical monitoring action group."
  value       = azurerm_monitor_action_group.critical.id
}
