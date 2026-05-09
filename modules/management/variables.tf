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

variable "log_analytics_retention" {
  description = "Log Analytics workspace retention in days."
  type        = number
  default     = 90
}

variable "alert_email_addresses" {
  description = "List of email addresses for monitoring alerts."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
