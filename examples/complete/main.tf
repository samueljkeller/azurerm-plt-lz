terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0, < 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.43.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

module "platform_landing_zone" {
  source = "../../"

  # Management Group Configuration
  root_management_group_id           = "example-root-mg"
  root_management_group_display_name = "Contoso"
  platform_management_group_name     = "Platform"
  connectivity_management_group_name = "Connectivity"
  identity_management_group_name     = "Identity"
  management_management_group_name   = "Management"

  landing_zones = {
    corp = {
      display_name  = "Corp"
      subscriptions = []
    }
    online = {
      display_name  = "Online"
      subscriptions = []
    }
  }

  # Subscription IDs
  management_subscription_id   = "00000000-0000-0000-0000-000000000001"
  connectivity_subscription_id = "00000000-0000-0000-0000-000000000002"
  identity_subscription_id     = "00000000-0000-0000-0000-000000000003"

  # Common Configuration
  location    = "eastus"
  prefix      = "contoso"
  environment = "prod"

  # Log Analytics
  log_analytics_retention = 90

  # Networking
  hub_vnet_address_space           = ["10.0.0.0/16"]
  firewall_subnet_address_prefix   = "10.0.0.0/26"
  gateway_subnet_address_prefix    = "10.0.1.0/27"
  management_subnet_address_prefix = "10.0.2.0/24"
  enable_azure_firewall            = true
  enable_vpn_gateway               = true

  # Security
  security_contact_email = "security@contoso.com"
  security_contact_phone = "+1-555-000-0000"

  tags = {
    owner       = "platform-team"
    cost-center = "platform"
  }
}
