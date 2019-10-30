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

module "Dev-Network-RG" {
  source         = "../modules/resourceGroup"
  resource_group = var.Dev-Network-RG
}

module "Dev-VNet-Spoke" {
  source                   = "../modules/network/spokeVnet"
  resource_group           = module.Dev-Network-RG.resource_group
  virtual_network          = var.Dev-VNet
  subnets                  = var.Dev-Subnets
  spoke_vnet_peering       = var.Dev-Hub-Peering
  hub_vnet_peering         = var.Hub-Dev-Peering
  hub_vnet                 = data.terraform_remote_state.Hub-Ref.outputs.Hub-Vnet
  providers = {
    azurerm.remote = "azurerm.prod"
  }
}


# module "Dev-AzureBastionSubnet-NSG" {
#   source         = "../modules/network/nsgSet"
#   resource_group = module.Dev-Network-RG.resource_group
#   nsg_name       = var.Dev-AzureBastionHost-NSG
#   nsg_rule_set   = var.Dev-AzureBastionHost-NSG-Rules
#   # Needs to match with the one assigned in subnet.
#   subnet_id_list = [
#     lookup(module.Dev-VNet-Spoke.subnets, local.AzureBastionSubnet, "")
#   ]
# }