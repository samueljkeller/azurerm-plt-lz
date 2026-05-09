resource "azurerm_resource_group" "connectivity" {
  name     = "rg-${var.prefix}-connectivity-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.prefix}-hub-${var.environment}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = var.hub_vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_address_prefix]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_address_prefix]
}

resource "azurerm_subnet" "management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.management_subnet_address_prefix]
}

resource "azurerm_network_security_group" "management" {
  name                = "nsg-${var.prefix}-management-${var.environment}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  tags                = var.tags

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

# Azure Firewall (optional)
resource "azurerm_public_ip" "firewall" {
  count = var.enable_azure_firewall ? 1 : 0

  name                = "pip-${var.prefix}-firewall-${var.environment}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "hub" {
  count = var.enable_azure_firewall ? 1 : 0

  name                = "afwp-${var.prefix}-hub-${var.environment}"
  resource_group_name = azurerm_resource_group.connectivity.name
  location            = azurerm_resource_group.connectivity.location
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "hub" {
  count = var.enable_azure_firewall ? 1 : 0

  name                = "afw-${var.prefix}-hub-${var.environment}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.hub[0].id
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  count = var.enable_azure_firewall ? 1 : 0

  name                       = "diag-${var.prefix}-firewall-${var.environment}"
  target_resource_id         = azurerm_firewall.hub[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_resource_id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  metric {
    category = "AllMetrics"
  }
}

# Route table to force traffic through Azure Firewall
resource "azurerm_route_table" "hub_to_firewall" {
  count = var.enable_azure_firewall ? 1 : 0

  name                          = "rt-${var.prefix}-hub-to-fw-${var.environment}"
  location                      = azurerm_resource_group.connectivity.location
  resource_group_name           = azurerm_resource_group.connectivity.name
  bgp_route_propagation_enabled = false
  tags                          = var.tags

  route {
    name                   = "DefaultRoute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub[0].ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "management" {
  count = var.enable_azure_firewall ? 1 : 0

  subnet_id      = azurerm_subnet.management.id
  route_table_id = azurerm_route_table.hub_to_firewall[0].id
}

# VPN Gateway (optional)
resource "azurerm_public_ip" "vpn_gateway" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = "pip-${var.prefix}-vpngw-${var.environment}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = "vgw-${var.prefix}-hub-${var.environment}"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw2AZ"
  active_active       = false
  enable_bgp          = true
  tags                = var.tags

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
}

# Hub VNet diagnostics
resource "azurerm_monitor_diagnostic_setting" "hub_vnet" {
  name                       = "diag-${var.prefix}-hub-vnet-${var.environment}"
  target_resource_id         = azurerm_virtual_network.hub.id
  log_analytics_workspace_id = var.log_analytics_workspace_resource_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
  }
}
