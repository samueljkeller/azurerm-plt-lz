resource "azurerm_resource_group" "management" {
  name     = "rg-${var.prefix}-management-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "management" {
  name                = "log-${var.prefix}-management-${var.environment}"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention
  tags                = var.tags
}

resource "azurerm_log_analytics_solution" "security_center" {
  solution_name         = "SecurityCenterFree"
  location              = azurerm_resource_group.management.location
  resource_group_name   = azurerm_resource_group.management.name
  workspace_resource_id = azurerm_log_analytics_workspace.management.id
  workspace_name        = azurerm_log_analytics_workspace.management.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityCenterFree"
  }
}

resource "azurerm_log_analytics_solution" "vm_insights" {
  solution_name         = "VMInsights"
  location              = azurerm_resource_group.management.location
  resource_group_name   = azurerm_resource_group.management.name
  workspace_resource_id = azurerm_log_analytics_workspace.management.id
  workspace_name        = azurerm_log_analytics_workspace.management.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}

resource "azurerm_log_analytics_solution" "service_map" {
  solution_name         = "ServiceMap"
  location              = azurerm_resource_group.management.location
  resource_group_name   = azurerm_resource_group.management.name
  workspace_resource_id = azurerm_log_analytics_workspace.management.id
  workspace_name        = azurerm_log_analytics_workspace.management.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ServiceMap"
  }
}

resource "azurerm_automation_account" "management" {
  name                = "aa-${var.prefix}-management-${var.environment}"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  sku_name            = "Basic"
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_log_analytics_linked_service" "automation" {
  resource_group_name = azurerm_resource_group.management.name
  workspace_id        = azurerm_log_analytics_workspace.management.id
  read_access_id      = azurerm_automation_account.management.id
}

resource "azurerm_monitor_action_group" "critical" {
  name                = "ag-${var.prefix}-critical-${var.environment}"
  resource_group_name = azurerm_resource_group.management.name
  short_name          = "critical"
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.alert_email_addresses

    content {
      name                    = "email-${email_receiver.key}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }
}

resource "azurerm_monitor_activity_log_alert" "service_health" {
  name                = "ala-${var.prefix}-service-health-${var.environment}"
  resource_group_name = azurerm_resource_group.management.name
  scopes              = ["/subscriptions/${var.management_subscription_id}"]
  description         = "Alert on Azure Service Health events"
  tags                = var.tags

  criteria {
    category = "ServiceHealth"
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical.id
  }
}
