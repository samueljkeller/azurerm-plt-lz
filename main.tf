module "management_groups" {
  source = "./modules/management_groups"

  root_management_group_display_name = var.root_management_group_display_name
  root_management_group_id           = var.root_management_group_id
  landing_zones                      = var.landing_zones
  platform_management_group_name     = var.platform_management_group_name
  connectivity_management_group_name = var.connectivity_management_group_name
  identity_management_group_name     = var.identity_management_group_name
  management_management_group_name   = var.management_management_group_name
}

module "management" {
  source = "./modules/management"

  location                   = var.location
  management_subscription_id = var.management_subscription_id
  prefix                     = var.prefix
  environment                = var.environment
  log_analytics_retention    = var.log_analytics_retention
  tags                       = local.default_tags

  providers = {
    azurerm = azurerm.management
  }
}

module "identity" {
  source = "./modules/identity"

  location                            = var.location
  identity_subscription_id            = var.identity_subscription_id
  prefix                              = var.prefix
  environment                         = var.environment
  tags                                = local.default_tags
  log_analytics_workspace_resource_id = module.management.log_analytics_workspace_resource_id

  providers = {
    azurerm = azurerm.identity
  }

  depends_on = [module.management]
}

module "networking" {
  source = "./modules/networking"

  location                            = var.location
  connectivity_subscription_id        = var.connectivity_subscription_id
  prefix                              = var.prefix
  environment                         = var.environment
  tags                                = local.default_tags
  hub_vnet_address_space              = var.hub_vnet_address_space
  gateway_subnet_address_prefix       = var.gateway_subnet_address_prefix
  firewall_subnet_address_prefix      = var.firewall_subnet_address_prefix
  management_subnet_address_prefix    = var.management_subnet_address_prefix
  enable_vpn_gateway                  = var.enable_vpn_gateway
  enable_azure_firewall               = var.enable_azure_firewall
  log_analytics_workspace_resource_id = module.management.log_analytics_workspace_resource_id

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [module.management]
}

module "policy" {
  source = "./modules/policy"

  root_management_group_id            = module.management_groups.root_management_group_id
  landing_zone_management_group_id    = module.management_groups.landing_zones_management_group_id
  platform_management_group_id        = module.management_groups.platform_management_group_id
  log_analytics_workspace_id          = module.management.log_analytics_workspace_id
  log_analytics_workspace_resource_id = module.management.log_analytics_workspace_resource_id
  management_subscription_id          = var.management_subscription_id

  depends_on = [module.management_groups, module.management]
}

module "security" {
  source = "./modules/security"

  location                            = var.location
  management_subscription_id          = var.management_subscription_id
  prefix                              = var.prefix
  environment                         = var.environment
  tags                                = local.default_tags
  log_analytics_workspace_resource_id = module.management.log_analytics_workspace_resource_id
  security_contact_email              = var.security_contact_email
  security_contact_phone              = var.security_contact_phone

  providers = {
    azurerm = azurerm.management
  }

  depends_on = [module.management]
}
