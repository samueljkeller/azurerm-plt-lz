variable "root_management_group_id" {
  description = "The ID of the root management group."
  type        = string
}

variable "root_management_group_display_name" {
  description = "The display name of the root management group."
  type        = string
  default     = "Tenant Root Group"
}

variable "platform_management_group_name" {
  description = "Name for the Platform management group."
  type        = string
  default     = "Platform"
}

variable "connectivity_management_group_name" {
  description = "Name for the Connectivity management group."
  type        = string
  default     = "Connectivity"
}

variable "identity_management_group_name" {
  description = "Name for the Identity management group."
  type        = string
  default     = "Identity"
}

variable "management_management_group_name" {
  description = "Name for the Management management group."
  type        = string
  default     = "Management"
}

variable "landing_zones" {
  description = "Map of landing zone management groups to create."
  type = map(object({
    display_name  = string
    subscriptions = optional(list(string), [])
  }))
  default = {}
}
