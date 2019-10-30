# resource "azurerm_resource_group" "rg" {

#         foreach = var.rg_map
#             name = x.key
#             location = x.value           
# }

# module "Test-Hub" {
#   source          = "../modules/hub2"
#   resource_group  = var.Hub2-Network-RG
#   virtual_network = var.Hub2-VNet
#   subnets         = var.Hub2-Subnets
#   # subnet_nsg = {<subnet name> = <nsg id>}
#   # Need to assign this in ns.
#   subnet_nsg = {
#     #"${local.ExtWAFSubnet}" = module.Hub-ExtWAF-NSG.nsg.id,
#     #"${local.IntWAFSubnet}" = module.Hub-IntWAF-NSG.nsg.id,
#     #"${local.HubNet01}"     = module.Hub-Net01-NSG.nsg.id,
#     #"${local.HubWADNet01}"  = module.Hub-WAD-Net01-NSG.nsg.id
#   }
# }

# module "Hub2-ExtWAF-NSG" {
#   source         = "../modules/network/nsgSet"
#   resource_group = module.Prod-Hub.resource_group
#   nsg_name       = var.Hub2-ExtWAF-NSG
#   nsg_rule_set   = var.Hub2-ExtWAF-NSG-Rules
#   # Needs to match with the one assigned in subnet.
#   subnet_id_list = [
#     #lookup(module.Test-Hub.subnets, local.ExtWAFSubnet, "")
#   ]
# }


# output "test" {
#   value = module.Prod-Hub.subnets["Hub-Net01"]
#   #value       = module.Prod-Hub.subnets["Hub-Net01"]
# }