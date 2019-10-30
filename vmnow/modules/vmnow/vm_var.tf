variable "location" {
  default = "southeastasia"
}

variable "virtual_machine" {
  default = {
    prefix             = "vm" # lowercase letters only, for storage account naming
    admin_username     = "jorseng"
    admin_password     = "jspassword90"
    vm_size            = "Standard_DS2_v3"
    managed_disk_type  = "StandardSSD_LRS"
    vnet_address_space = ["10.0.0.0/16"]
    subnet_cidr        = "10.0.1.0/24"
  }
}

variable "new_data_disk" {
  default = {
    #"lun" = ["managed_disk_type", "disk_size_gb"]
    "0" = ["Standard_LRS", "64"]
  }
}

variable "attach_data_disk" {
  default = {
    # lun here should not overlap with lun in "new_data_disk"
    # "1" = ["ref_disk_name", "ref_disk_id", ref_disk_size_gb""]
  }
}
