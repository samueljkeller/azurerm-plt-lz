resource "azurerm_security_center_workspace" "management" {
  scope        = "/subscriptions/${var.management_subscription_id}"
  workspace_id = var.log_analytics_workspace_resource_id
}

resource "azurerm_security_center_subscription_pricing" "defender_servers" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_storage" {
  tier          = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "defender_sql_servers" {
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "defender_sql_vm" {
  tier          = "Standard"
  resource_type = "SqlServerVirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_containers" {
  tier          = "Standard"
  resource_type = "Containers"
}

resource "azurerm_security_center_subscription_pricing" "defender_key_vault" {
  tier          = "Standard"
  resource_type = "KeyVaults"
}

resource "azurerm_security_center_subscription_pricing" "defender_arm" {
  tier          = "Standard"
  resource_type = "Arm"
}

resource "azurerm_security_center_subscription_pricing" "defender_dns" {
  tier          = "Standard"
  resource_type = "Dns"
}

resource "azurerm_security_center_subscription_pricing" "defender_app_services" {
  tier          = "Standard"
  resource_type = "AppServices"
}

resource "azurerm_security_center_contact" "main" {
  count = var.security_contact_email != "" ? 1 : 0

  email               = var.security_contact_email
  phone               = var.security_contact_phone
  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_resource_group" "security" {
  name     = "rg-${var.prefix}-security-${var.environment}"
  location = var.location
  tags     = var.tags
}
