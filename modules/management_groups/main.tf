resource "azurerm_management_group" "root" {
  name         = var.root_management_group_id
  display_name = var.root_management_group_display_name
}

resource "azurerm_management_group" "platform" {
  name                       = var.platform_management_group_name
  display_name               = var.platform_management_group_name
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "connectivity" {
  name                       = var.connectivity_management_group_name
  display_name               = var.connectivity_management_group_name
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "identity" {
  name                       = var.identity_management_group_name
  display_name               = var.identity_management_group_name
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "management" {
  name                       = var.management_management_group_name
  display_name               = var.management_management_group_name
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "LandingZones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "landing_zone" {
  for_each = var.landing_zones

  name                       = each.key
  display_name               = each.value.display_name
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group_subscription_association" "landing_zone" {
  for_each = {
    for pair in flatten([
      for lz_key, lz_value in var.landing_zones : [
        for sub in lz_value.subscriptions : {
          key          = "${lz_key}-${sub}"
          lz_key       = lz_key
          subscription = sub
        }
      ]
    ]) : pair.key => pair
  }

  management_group_id = azurerm_management_group.landing_zone[each.value.lz_key].id
  subscription_id     = "/subscriptions/${each.value.subscription}"
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "Decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "sandboxes" {
  name                       = "Sandboxes"
  display_name               = "Sandboxes"
  parent_management_group_id = azurerm_management_group.root.id
}
