variable "root_management_group_id" {
  description = "The ID of the root management group."
  type        = string
}

variable "landing_zone_management_group_id" {
  description = "The ID of the Landing Zones management group."
  type        = string
}

variable "platform_management_group_id" {
  description = "The ID of the Platform management group."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The workspace ID of the central Log Analytics workspace."
  type        = string
}

variable "log_analytics_workspace_resource_id" {
  description = "The resource ID of the central Log Analytics workspace."
  type        = string
}

variable "management_subscription_id" {
  description = "The management subscription ID."
  type        = string
}

variable "policy_assignment_location" {
  description = "The Azure region for policy assignments with managed identities."
  type        = string
  default     = "eastus"
}
