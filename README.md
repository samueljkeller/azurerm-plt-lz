# azurerm-plt-lz

Azure Platform Landing Zone Terraform Accelerator

This module implements an [Azure Landing Zone](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) for enterprise-scale platform deployments following the [Microsoft Cloud Adoption Framework (CAF)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/).

## Architecture

The landing zone deploys the following components:

```
Tenant Root Group
├── <Root Management Group>
│   ├── Platform
│   │   ├── Connectivity  ─── Hub VNet, Azure Firewall, VPN Gateway
│   │   ├── Identity      ─── Key Vault, Managed Identities
│   │   └── Management    ─── Log Analytics, Automation Account, Monitoring
│   ├── Landing Zones
│   │   ├── Corp
│   │   ├── Online
│   │   └── Sandbox
│   ├── Decommissioned
│   └── Sandboxes
```

### Modules

| Module | Description |
|--------|-------------|
| `management_groups` | Azure Management Group hierarchy (root → platform → landing zones) |
| `management` | Log Analytics workspace, Automation Account, and monitoring alerts |
| `networking` | Hub virtual network with Azure Firewall, VPN Gateway, and subnets |
| `identity` | Key Vault (premium, purge-protected) and platform managed identity |
| `policy` | Azure Policy assignments following CAF security and governance recommendations |
| `security` | Microsoft Defender for Cloud plans and security contacts |

## Prerequisites

- Terraform >= 1.5.0
- Azure subscription(s) for management, connectivity, and identity
- Sufficient permissions: Global Administrator or Owner at root management group
- Azure CLI authenticated (`az login`)

## Usage

```hcl
module "platform_landing_zone" {
  source = "github.com/samueljkeller/azurerm-plt-lz"

  root_management_group_id   = "contoso"
  management_subscription_id   = "<management-subscription-id>"
  connectivity_subscription_id = "<connectivity-subscription-id>"
  identity_subscription_id     = "<identity-subscription-id>"

  location    = "eastus"
  prefix      = "contoso"
  environment = "prod"

  hub_vnet_address_space           = ["10.0.0.0/16"]
  firewall_subnet_address_prefix   = "10.0.0.0/26"
  gateway_subnet_address_prefix    = "10.0.1.0/27"
  management_subnet_address_prefix = "10.0.2.0/24"
  enable_azure_firewall            = true
  enable_vpn_gateway               = true

  security_contact_email = "security@contoso.com"
}
```

See [`examples/complete`](./examples/complete) for a full example.

## Backend Configuration

It is recommended to use a remote backend. Create a `backend.tfvars` file:

```hcl
resource_group_name  = "rg-terraform-state"
storage_account_name = "stterraformstate"
container_name       = "tfstate"
key                  = "platform-landing-zone.tfstate"
```

Then initialize with:

```bash
terraform init -backend-config=backend.tfvars
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `root_management_group_id` | ID of the root management group | `string` | n/a | yes |
| `management_subscription_id` | Management subscription ID | `string` | n/a | yes |
| `connectivity_subscription_id` | Connectivity subscription ID | `string` | n/a | yes |
| `identity_subscription_id` | Identity subscription ID | `string` | n/a | yes |
| `location` | Primary Azure region | `string` | `"eastus"` | no |
| `prefix` | Resource naming prefix | `string` | `"plt"` | no |
| `environment` | Environment name | `string` | `"prod"` | no |
| `hub_vnet_address_space` | Hub VNet address space | `list(string)` | `["10.0.0.0/16"]` | no |
| `firewall_subnet_address_prefix` | AzureFirewallSubnet prefix | `string` | `"10.0.0.0/26"` | no |
| `gateway_subnet_address_prefix` | GatewaySubnet prefix | `string` | `"10.0.1.0/27"` | no |
| `management_subnet_address_prefix` | Management subnet prefix | `string` | `"10.0.2.0/24"` | no |
| `enable_azure_firewall` | Deploy Azure Firewall | `bool` | `true` | no |
| `enable_vpn_gateway` | Deploy VPN Gateway | `bool` | `true` | no |
| `log_analytics_retention` | Log retention days | `number` | `90` | no |
| `security_contact_email` | Security alert email | `string` | `""` | no |
| `landing_zones` | Landing zone management groups | `map(object)` | See variables | no |
| `tags` | Additional resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `root_management_group_id` | Root management group ID |
| `platform_management_group_id` | Platform management group ID |
| `landing_zones_management_group_id` | Landing Zones management group ID |
| `log_analytics_workspace_id` | Log Analytics workspace ID |
| `log_analytics_workspace_resource_id` | Log Analytics workspace resource ID |
| `hub_vnet_id` | Hub virtual network resource ID |
| `hub_vnet_name` | Hub virtual network name |
| `firewall_private_ip` | Azure Firewall private IP address |
| `vpn_gateway_id` | VPN Gateway resource ID |

## Security

This module implements the following security controls:

- **Azure Security Benchmark** policy initiative assigned at root management group
- **Microsoft Defender for Cloud** Standard tier for VMs, Storage, SQL, Containers, Key Vault, ARM, DNS, and App Services
- **Azure Firewall** in hub VNet with forced tunneling for spoke subnets
- **Key Vault** with purge protection, soft-delete, premium SKU, and network ACLs
- **NSG** on management subnet denying all inbound traffic by default
- **Policy** denying classic resources, public IPs on NICs, and internet-exposed RDP/SSH

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `terraform fmt -recursive` and `terraform validate`
5. Submit a pull request
