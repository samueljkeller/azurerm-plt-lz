output "security_benchmark_assignment_id" {
  description = "The resource ID of the Azure Security Benchmark policy assignment."
  value       = azurerm_management_group_policy_assignment.security_benchmark.id
}

output "log_analytics_policy_identity_principal_id" {
  description = "The principal ID of the Log Analytics policy assignment managed identity."
  value       = azurerm_management_group_policy_assignment.log_analytics_workspace.identity[0].principal_id
}
