variable "location" {
  description = "Azure region for resources."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Subscription ID for the connectivity subscription."
  type        = string
}

variable "prefix" {
  description = "Prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

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
  description = "Address prefix for the management subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "enable_vpn_gateway" {
  description = "Whether to deploy a VPN Gateway."
  type        = bool
  default     = true
}

variable "enable_azure_firewall" {
  description = "Whether to deploy Azure Firewall."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_resource_id" {
  description = "The resource ID of the Log Analytics workspace."
  type        = string
}
