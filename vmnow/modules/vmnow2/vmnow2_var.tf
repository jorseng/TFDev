variable "location" {
  default = "southeastasia"
}

variable "vmset" {
  default = {
    prefix             = "testname" # lowercase letters only, for storage account naming
    admin_username     = "jorseng"
    admin_password     = "jspassword9@"
    vnet_address_space = ["10.0.0.0/16"]
    subnet_cidr        = "10.0.1.0/24"
    vms   = {
      #"vmname" = ["vmsize","os_disk_type","os_disk_size_gb"]
      "vm1" = ["Standard_DS2_v3","StandardSSD_LRS","128"]
    }
  }
}
