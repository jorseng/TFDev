
module "Hub-WAD-RG" {
  source         = "../modules/resourceGroup"
  resource_group = var.Hub-WAD-RG
}

module "HUBWAD01" {
  source             = "../modules/compute/vm"
  resource_group     = module.Hub-WAD-RG.resource_group
  virtual_machine    = var.HUBWAD01
  new_data_disk      = var.HUBWAD01_Data_Disks
  image_reference_id = var.WS2016_CIS_L1_Image
  subnet_id          = module.Prod-Hub.subnets[local.HubWADNet01]
  storage_uri        = data.terraform_remote_state.Prod-Ref.outputs.prodvmbootdiagsa.primary_blob_endpoint
}

