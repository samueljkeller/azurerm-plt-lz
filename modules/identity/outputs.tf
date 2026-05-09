output "key_vault_id" {
  description = "The resource ID of the identity Key Vault."
  value       = azurerm_key_vault.identity.id
}

output "key_vault_uri" {
  description = "The URI of the identity Key Vault."
  value       = azurerm_key_vault.identity.vault_uri
}

output "platform_identity_id" {
  description = "The resource ID of the platform user-assigned managed identity."
  value       = azurerm_user_assigned_identity.platform.id
}

output "platform_identity_principal_id" {
  description = "The principal ID of the platform user-assigned managed identity."
  value       = azurerm_user_assigned_identity.platform.principal_id
}

output "identity_resource_group_name" {
  description = "The name of the identity resource group."
  value       = azurerm_resource_group.identity.name
}
