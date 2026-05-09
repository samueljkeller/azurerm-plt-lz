variable "location" {
  description = "Azure region for resources."
  type        = string
}

variable "management_subscription_id" {
  description = "Subscription ID for the management subscription."
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

variable "security_contact_email" {
  description = "Email address for security alerts."
  type        = string
  default     = ""
}

variable "security_contact_phone" {
  description = "Phone number for security alerts."
  type        = string
  default     = ""
}
