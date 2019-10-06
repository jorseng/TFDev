# Shared Resources

provider "azurerm" {
  version         = "1.34.0"
  subscription_id = "5b98ba7c-c3f7-43ec-ac20-195d8109fe2b"
}


# Resource Groups

module "Dev-Network-RG" {
  source         = "../modules/resourcegroup"
  resource_group = var.Dev-Network-RG
}

module "Dev-Security-RG" {
  source         = "../modules/resourcegroup"
  resource_group = var.Dev-Security-RG
}

module "Dev-Management-RG" {
  source         = "../modules/resourcegroup"
  resource_group = var.Dev-Management-RG
}


# Network
# Virtual Network

module "Dev-Vnet" {
  source          = "../modules/network/vnet"
  virtual_network = var.Dev-Vnet
  resource_group  = module.Dev-Network-RG.resource_group
}


# Subnet
module "GatewaySubnet" {
  source          = "../modules/network/subnet"
  resource_group  = module.Dev-Network-RG.resource_group
  virtual_network = module.Dev-Vnet.vnet
  subnet          = var.GatewaySubnet
}

module "AzureFirewallSubnet" {
  source          = "../modules/network/subnet"
  resource_group  = module.Dev-Network-RG.resource_group
  virtual_network = module.Dev-Vnet.vnet
  subnet          = var.AzureFirewallSubnet
}

module "Dev-ExtWAF-Net01" {
  source          = "../modules/network/subnet"
  resource_group  = module.Dev-Network-RG.resource_group
  virtual_network = module.Dev-Vnet.vnet
  subnet          = var.Dev-ExtWAF-Net01
}

module "Dev-Net01" {
  source          = "../modules/network/subnet"
  resource_group  = module.Dev-Network-RG.resource_group
  virtual_network = module.Dev-Vnet.vnet
  subnet          = var.Dev-Net01
}

# module "Dev-S2S-VPN" {
#   source          = "../modules/network/s2svpn"
#   resource_group  = module.Dev-Network-RG.resource_group
#   gw_pip          = var.Dev-GW01-PIP01
#   gateway_virtual = var.Dev-VPN-GW01
#   gw_subnet_id    = module.GatewaySubnet.subnet.id
#   gateway_local   = var.Dev-Onprem-GW01
#   s2s_connection  = var.s2sConnection
# }

# module "Dev-ER-GW01" {
#   source = "../modules/network/expressRoute"
#   resource_group = module.Dev-Network-RG.resource_group
#   express_route = var.expressRoute 
# }

module "Dev-FW01" {
  source = "../modules/network/firewall"
  resource_group = module.Dev-Network-RG.resource_group
  firewall = var.firewall
  fw_pip = var.fw_pip
  subnet_id = module.AzureFirewallSubnet.subnet.id
}
