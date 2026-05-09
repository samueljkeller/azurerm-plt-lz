variable "location" {
  description = "Azure region for resources."
  type        = string
}

variable "identity_subscription_id" {
  description = "Subscription ID for the identity subscription."
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

variable "log_analytics_workspace_resource_id" {
  description = "The resource ID of the Log Analytics workspace."
  type        = string
}

variable "key_vault_allowed_ips" {
  description = "List of IP addresses allowed to access the Key Vault."
  type        = list(string)
  default     = []
}
