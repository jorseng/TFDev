provider "azurerm" {
  version = "1.28.0"
}

module "mainrg" {
  source         = "./modules/resourcegroup"
  resource_group = var.rgroup
}

module "hub-vnet" {
  source          = "./modules/network/vnet"
  resource_group  = module.mainrg.resource_group
  virtual_network = var.vnet
  subnets         = var.subnets
}

# module "vm01" {
#   source         = "./modules/compute/vm"
#   resource_group = module.mainrg.resource_group
#   vm_profile     = var.vm_profile
#   os_profile     = var.os_profile
#   os_image       = var.os_image
#   subnet_id      = lookup(module.hub-vnet.subnets, "mgt-subnet", "")
# }

module "webserver-as" {
  source                   = "./modules/compute/availabilityset"
  vmcount                  = var.vmcount
  availability_set_profile = var.webserver_set_profile
  resource_group           = module.mainrg.resource_group
  vm_profile               = var.vm_profile
  os_profile               = var.os_profile
  os_image                 = var.os_image
  subnet_id                = lookup(module.hub-vnet.subnets, "mgt-subnet", "")
}

