# Shared Resources
provider "azurerm" {
  version         = "1.34.0"
  subscription_id = var.Subscription.id
}

module "Transit-Hub" {
  source          = "../modules/hub"
  resource_group  = var.Transit-Network-RG
  virtual_network = var.Transit-VNet
  subnets         = var.Transit-Subnets
}

module "Prod-ExtWAF-NSG" {
  source  = "../modules/network/nsgSet"
  resource_group = module.Transit-Hub.resource_group
  nsg_name = var.Prod-ExtWAF-NSG
  nsg_rule_set = var.Prod-ExtWAF-NSG-Rules
  subnet_id = lookup(module.Transit-Hub.subnets, "Prod-ExtWAF-Net01", "")
}



# module "Transit-S2S-VPN" {
#   source          = "../modules/network/s2svpn"
#   resource_group  = module.Transit-Hub.resource_group
#   gw_pip          = var.Transit-GW01-PIP01
#   gateway_virtual = var.Transit-VPN-GW01
#   gw_subnet_id    = lookup(module.Transit-Hub.subnets, "GatewaySubnet", "")
#   gateway_local   = var.Transit-Local-GW01
#   s2s_connection  = var.S2SConnection
# }

# module "Transit-ER" {
#   source         = "../modules/network/expressRoute"
#   resource_group = module.Transit-Hub.resource_group
#   express_route  = var.expressRoute
# }

# module "Transit-FW01" {
#   source         = "../modules/network/firewall"
#   resource_group = module.Transit-Hub.resource_group
#   firewall_name  = var.firewall_name
#   fw_pip         = var.fw_pip
#   subnet_id      = lookup(module.Transit-Hub.subnets, "AzureFirewallSubnet", "")
# }


# NAMING NOT RIGHT YET
# module "udr-table" {
#   source  = "../module_test/udr"
#   route_table_name = var.route_table_name
#   resource_group = azurerm_resource_group.udr-rg
#   routes = var.routes
#   subnet_id_list = []
# }