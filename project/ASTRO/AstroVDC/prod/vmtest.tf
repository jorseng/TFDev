# module "vmtest_rg" {
#   source  = "../modules/resourcegroup"
#   resource_group = var.resource_group
# }

# module "vmtestimage" {
#   source             = "../modules/compute/vm"
#   resource_group     = module.vmtest_rg.resource_group
#   virtual_machine    = var.virtual_machine
#   new_data_disk      = var.new_data_disk
#   image_reference_id = var.vm_image
#   subnet_id          = module.vmtest_subnet.subnet.id
#   storage_uri        = module.prodvmbootdiagsa.storage_account.primary_blob_endpoint
# }


# IN NETWORK,
# Create NSG, Subnet

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