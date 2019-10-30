locals {
  GatewaySubnet  = "GatewaySubnet"
  FirewallSubnet = "AzureFirewallSubnet"
  ExtWAFSubnet   = "Hub-ExtWAF-Net01"
  IntWAFSubnet   = "Hub-IntWAF-Net01"
  HubNet01       = "Hub-Net01"
  BastionSubnet  = "AzureBastionSubnet"
}

# Shared Resources
provider "azurerm" {
  version         = "1.34.0"
  subscription_id = var.Subscription.id
}

module "Prod-Hub" {
  source          = "../modules/hub"
  resource_group  = var.Hub-Network-RG
  virtual_network = var.Hub-VNet
  subnets         = var.Hub-Subnets
  # subnet_nsg = {<subnet name> = <nsg id>}
  # Need to assign this in ns.
  subnet_nsg = {
    "${local.ExtWAFSubnet}" = module.Hub-ExtWAF-NSG.nsg.id,
    "${local.IntWAFSubnet}" = module.Hub-IntWAF-NSG.nsg.id,
    "${local.HubNet01}"     = module.Hub-Net01-NSG.nsg.id
  }
}

module "Hub-ExtWAF-NSG" {
  source         = "../modules/network/nsgSet"
  resource_group = module.Prod-Hub.resource_group
  nsg_name       = var.Hub-ExtWAF-NSG
  nsg_rule_set   = var.Hub-ExtWAF-NSG-Rules
  # Needs to match with the one assigned in subnet.
  subnet_id_list = [
    lookup(module.Prod-Hub.subnets, local.ExtWAFSubnet, "")
  ]
}

module "Hub-IntWAF-NSG" {
  source         = "../modules/network/nsgSet"
  resource_group = module.Prod-Hub.resource_group
  nsg_name       = var.Hub-IntWAF-NSG
  nsg_rule_set   = var.Hub-IntWAF-NSG-Rules
  # Needs to match with the one assigned in subnet.
  subnet_id_list = [
    lookup(module.Prod-Hub.subnets, local.IntWAFSubnet, "")
  ]
}

module "Hub-Net01-NSG" {
  source         = "../modules/network/nsgSet"
  resource_group = module.Prod-Hub.resource_group
  nsg_name       = var.Hub-Net01-NSG
  nsg_rule_set   = var.Hub-Net01-NSG-Rules
  # Needs to match with the one assigned in subnet.
  subnet_id_list = [
    lookup(module.Prod-Hub.subnets, local.HubNet01, "")
  ]
}

# module "Hub-Az-FW01" {
#   source                  = "../modules/network/firewall"
#   resource_group          = module.Prod-Hub.resource_group
#   fw_pip                  = var.fw_pip
#   firewall_name           = var.firewall_name
#   subnet_id               = lookup(module.Prod-Hub.subnets, local.FirewallSubnet, "")
#   nat_rule_collection     = var.nat_rule_collection
#   network_rule_collection = var.network_rule_collection
#   app_rule_collection     = var.app_rule_collection
# }

# module "Hub-ER-GW01" {
#   source          = "../modules/network/gatewayVirtual"
#   resource_group  = module.Prod-Hub.resource_group
#   gateway_virtual = var.Hub-ER-GW01
#   gw_pip          = var.Hub-ER-GW01-PIP01
#   gw_subnet_id    = lookup(module.Prod-Hub.subnets, local.GatewaySubnet, "")
# }

# module "Hub-ER-Circuit" {
#   source         = "../modules/network/expressRoute"
#   resource_group = module.Prod-Hub.resource_group
#   express_route  = var.expressRoute
# }

# module "Hub-S2S-VPN" {
#   source          = "../modules/network/s2svpn"
#   resource_group  = module.Prod-Hub.resource_group
#   gw_pip          = var.Hub-VPN-GW01-PIP01
#   gateway_virtual = var.Hub-VPN-GW01
#   gw_subnet_id    = lookup(module.Prod-Hub.subnets, local.GatewaySubnet, "")
#   gateway_local   = var.Hub-Local-VPN-GW01
#   s2s_connection  = var.S2SConnection
# }

module "Hub-Ext-DMZ-APPGW01" {
  source                     = "../modules/network/appGateway"
  resource_group             = module.Prod-Hub.resource_group
  appgw_subnet_id            = lookup(module.Prod-Hub.subnets, local.ExtWAFSubnet, "")
  appgw_pip                  = var.Hub-Ext-DMZ-APPGW01-PIP01
  application_gateway_config = var.Hub-Ext-DMZ-APPGW01
}


# NAMING NOT RIGHT YET
# module "udr-table" {
#   source  = "../module_test/udr"
#   route_table_name = var.route_table_name
#   resource_group = azurerm_resource_group.udr-rg
#   routes = var.routes
#   subnet_id_list = []
# }