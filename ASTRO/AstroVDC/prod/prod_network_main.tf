locals {
  AzureBastionSubnet = "AzureBastionSubnet"
}


provider "azurerm" {
  version         = "1.34.0"
  subscription_id = var.Subscription.dev_id
  alias           = "dev"
}

provider "azurerm" {
  version         = "1.34.0"
  subscription_id = var.Subscription.prod_id
  alias           = "prod"
}

# NETWORK - VNET

module "Prod-Network-RG" {
  source         = "../modules/resourceGroup"
  resource_group = var.Prod-Network-RG
}

module "Prod-VNet-Spoke" {
  source                   = "../modules/network/spokeVnet"
  resource_group           = module.Prod-Network-RG.resource_group
  virtual_network          = var.Prod-VNet
  subnets                  = var.Prod-Subnets
  spoke_vnet_peering       = var.Prod-Hub-Peering
  hub_vnet_peering         = var.Hub-Prod-Peering
  hub_vnet                 = data.terraform_remote_state.Hub-Ref.outputs.Hub-Vnet
  providers = {
    azurerm.remote = "azurerm.prod"
  }
}

# NETWORK - APP SUBNET & NSG

# module "vmtest_subnet" {
#   source  = "../modules/network/subnet"
#   subnet = var.subnet
#   virtual_network = module.Prod-VNet-Spoke.vnet.name
#   resource_group = module.Prod-Network-RG.resource_group
#   #network_security_group_id = var.nsg_id
# }


# module "Prod-AzureBastionSubnet-NSG" {
#   source         = "../modules/network/nsgSet"
#   resource_group = module.Prod-VNet-Spoke.resource_group
#   nsg_name       = var.Prod-AzureBastion-NSG
#   nsg_rule_set   = var.Prod-AzureBastion-NSG-Rules
#   # Needs to match with the one assigned in subnet.
#   subnet_id_list = [
#     lookup(module.Prod-VNet-Spoke.subnets, local.AzureBastionSubnet, "")
#   ]
# }