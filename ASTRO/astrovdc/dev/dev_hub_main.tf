provider "azurerm" {
  version         = "1.34.0"
  subscription_id = var.Subscription.id
}

module "dev-network-rg" {
  source         = "../modules/resourceGroup"
  resource_group = var.hub-network-rg
}

module "dev-hub" {
  source                   = "../modules/network/spokeVnet"
  resource_group           = module.dev-network-rg.resource_group
  virtual_network          = var.hub-vnet
  subnets                  = var.hub-subnets
  local_vnet_peering_name  = var.dev-transit-peering
  remote_vnet_peering_name = var.transit-dev-peering
  remote_vnet              = data.terraform_remote_state.transit-vnet.outputs.transit-vnet
}

# DATA
data "terraform_remote_state" "transit-vnet" {
  backend = "local"
  config = {
    path = "../transit/terraform.tfstate"
  }
}

