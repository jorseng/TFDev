##########################################################################
#   LOG ANALYTICS                                                       
##########################################################################

module "Prod-LAW-01" {
  source         = "../modules/logAnalytics"
  resource_group = var.Prod-Monitor-RG
  log_analytics  = var.Prod-LAW-01
}

##########################################################################
#   BOOT DIAGNOSTIC STORAGE ACCOUNT                                                       
##########################################################################

module "Prod-Mgmt-RG" {
  source         = "../modules/resourceGroup"
  resource_group = var.Prod-Mgmt-RG
}

module "prodvmbootdiagsa" {
  source          = "../modules/storage/storageAccount"
  storage_account = var.prodvmbootdiagsa
  resource_group  = module.Prod-Mgmt-RG.resource_group
}