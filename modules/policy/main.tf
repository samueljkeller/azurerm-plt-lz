# Assign Azure Security Benchmark at root management group
resource "azurerm_management_group_policy_assignment" "security_benchmark" {
  name                 = "azure-security-benchmark"
  display_name         = "Azure Security Benchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  management_group_id  = var.root_management_group_id
  description          = "The Azure Security Benchmark initiative represents the policies and controls implementing security recommendations defined in Azure Security Benchmark v3, see https://aka.ms/azsecbm."
}

# Require tags on resource groups
resource "azurerm_management_group_policy_assignment" "require_tags_rg" {
  name                 = "require-tags-rg"
  display_name         = "Require tags on resource groups"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  management_group_id  = var.root_management_group_id
  description          = "Enforces a required tag and its value for resource groups."

  parameters = jsonencode({
    tagName = {
      value = "environment"
    }
  })
}

# Deny creation of classic resources at root
resource "azurerm_management_group_policy_assignment" "deny_classic_resources" {
  name                 = "deny-classic-resources"
  display_name         = "Deny classic resource types"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  management_group_id  = var.root_management_group_id
  description          = "Denies deployment of classic compute, network, and storage resources."
}

# Enable Microsoft Defender for Cloud - standard plan (DINE policy)
resource "azurerm_management_group_policy_assignment" "defender_cloud" {
  name                 = "enable-defender-cloud"
  display_name         = "Enable Microsoft Defender for Cloud"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  management_group_id  = var.landing_zone_management_group_id
  description          = "Enables Microsoft Defender for Cloud for all subscriptions in the Landing Zones management group."
  enforce              = false
}

# Configure Log Analytics workspace for subscriptions (DINE)
resource "azurerm_management_group_policy_assignment" "log_analytics_workspace" {
  name                 = "configure-la-workspace"
  display_name         = "Configure Log Analytics workspace and automation account"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/0d1b56c7-6cfa-4aa8-a464-d0d3a99c3bca"
  management_group_id  = var.root_management_group_id
  description          = "Configure machines to automatically install the Azure Monitor and Azure Security agents with Log Analytics workspace."
  location             = var.policy_assignment_location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode({
    logAnalyticsWorkspaceId = {
      value = var.log_analytics_workspace_resource_id
    }
  })
}

# Role assignment for policy managed identity
resource "azurerm_role_assignment" "policy_log_analytics_contributor" {
  scope                = var.log_analytics_workspace_resource_id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.log_analytics_workspace.identity[0].principal_id
}

# Deny public IP addresses on NICs in landing zones
resource "azurerm_management_group_policy_assignment" "deny_public_ip" {
  name                 = "deny-public-ip-on-nic"
  display_name         = "Deny public IP addresses on NICs"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-ddc1fbb1c7a6"
  management_group_id  = var.landing_zone_management_group_id
  description          = "Prevents creation of public IP addresses attached to NICs in landing zone subscriptions."
  enforce              = false
}

# Deny RDP access from internet
resource "azurerm_management_group_policy_assignment" "deny_rdp_from_internet" {
  name                 = "deny-rdp-from-internet"
  display_name         = "Deny RDP access from Internet"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e372f825-a257-4fb8-9175-797a8a8627d6"
  management_group_id  = var.landing_zone_management_group_id
  description          = "Denies inbound RDP rules from the Internet on NSGs."
  enforce              = false
}

# Deny SSH access from internet
resource "azurerm_management_group_policy_assignment" "deny_ssh_from_internet" {
  name                 = "deny-ssh-from-internet"
  display_name         = "Deny SSH access from Internet"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/2c89a2e5-7285-40fe-afe0-ae8654b92fab"
  management_group_id  = var.landing_zone_management_group_id
  description          = "Denies inbound SSH rules from the Internet on NSGs."
  enforce              = false
}
