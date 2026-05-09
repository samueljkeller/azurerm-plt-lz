data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "identity" {
  name     = "rg-${var.prefix}-identity-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "identity" {
  name                        = "kv-${var.prefix}-ident-${var.environment}"
  location                    = azurerm_resource_group.identity.location
  resource_group_name         = azurerm_resource_group.identity.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  sku_name                    = "premium"
  tags                        = var.tags

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.key_vault_allowed_ips
  }
}

resource "azurerm_key_vault_access_policy" "terraform_deployer" {
  key_vault_id = azurerm_key_vault.identity.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Recover", "Purge",
    "GetRotationPolicy", "SetRotationPolicy"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Purge"
  ]

  certificate_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Recover", "Purge"
  ]
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-${var.prefix}-kv-${var.environment}"
  target_resource_id         = azurerm_key_vault.identity.id
  log_analytics_workspace_id = var.log_analytics_workspace_resource_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_user_assigned_identity" "platform" {
  name                = "id-${var.prefix}-platform-${var.environment}"
  resource_group_name = azurerm_resource_group.identity.name
  location            = azurerm_resource_group.identity.location
  tags                = var.tags
}
