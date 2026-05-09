# Root Management Group
variable "root_management_group_id" {
  description = "The ID of the root management group to deploy the landing zone under."
  type        = string
}

variable "root_management_group_display_name" {
  description = "The display name of the root management group."
  type        = string
  default     = "Tenant Root Group"
}

# Management Group Names
variable "platform_management_group_name" {
  description = "Name for the Platform management group."
  type        = string
  default     = "Platform"
}

variable "connectivity_management_group_name" {
  description = "Name for the Connectivity management group under Platform."
  type        = string
  default     = "Connectivity"
}

variable "identity_management_group_name" {
  description = "Name for the Identity management group under Platform."
  type        = string
  default     = "Identity"
}

variable "management_management_group_name" {
  description = "Name for the Management management group under Platform."
  type        = string
  default     = "Management"
}

variable "landing_zones" {
  description = "Map of landing zone management groups to create."
  type = map(object({
    display_name  = string
    subscriptions = optional(list(string), [])
  }))
  default = {
    corp = {
      display_name = "Corp"
    }
    online = {
      display_name = "Online"
    }
    sandbox = {
      display_name = "Sandbox"
    }
  }
}

# Subscriptions
variable "management_subscription_id" {
  description = "Subscription ID for the Management subscription."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Subscription ID for the Connectivity subscription."
  type        = string
}

variable "identity_subscription_id" {
  description = "Subscription ID for the Identity subscription."
  type        = string
}

# Common
variable "location" {
  description = "Primary Azure region for deploying resources."
  type        = string
  default     = "eastus"
}

variable "prefix" {
  description = "Prefix to use for resource naming."
  type        = string
  default     = "plt"
}

variable "environment" {
  description = "Environment name (e.g. prod, dev, staging)."
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

# Log Analytics
variable "log_analytics_retention" {
  description = "Number of days to retain logs in Log Analytics workspace."
  type        = number
  default     = 90
}

# Networking
variable "hub_vnet_address_space" {
  description = "Address space for the hub virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "gateway_subnet_address_prefix" {
  description = "Address prefix for the GatewaySubnet."
  type        = string
  default     = "10.0.1.0/27"
}

variable "firewall_subnet_address_prefix" {
  description = "Address prefix for the AzureFirewallSubnet."
  type        = string
  default     = "10.0.0.0/26"
}

variable "management_subnet_address_prefix" {
  description = "Address prefix for the management subnet in the hub VNet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "enable_vpn_gateway" {
  description = "Whether to deploy an Azure VPN Gateway in the hub."
  type        = bool
  default     = true
}

variable "enable_azure_firewall" {
  description = "Whether to deploy Azure Firewall in the hub."
  type        = bool
  default     = true
}

# Security
variable "security_contact_email" {
  description = "Email address for Microsoft Defender for Cloud security alerts."
  type        = string
  default     = ""
}

variable "security_contact_phone" {
  description = "Phone number for Microsoft Defender for Cloud security alerts."
  type        = string
  default     = ""
}
