provider "azurerm"{
    subscription_id = var.subscription.id
}

variable "subscription" {
  default     = {
      id = "1431443c-49d2-4e4e-8569-e899fc5e5143" #JS MPN subscription
  }
}


##############################################################################################
variable "vm1" {
  default = {
    # WARNING: this module, deleted disk on termination
    # prefix lowercase letters only, for storage account naming
    prefix                = "vm1" 
    admin_username        = "jorseng"       # \jorseng at login
    admin_password        = "jspassword9@" 
    vm_size               = "Standard_D2s_v3"
    os_disk_type          = "StandardSSD_LRS"
    vnet_address_space    = ["10.0.0.0/16"]
    subnet_cidr           = "10.0.1.0/24"
    domain_name_label     = "jsvmtest"      # jsvmtest.southeastasia.cloudapp.azure.com
    new_data_disk      = {
      #"0" = ["Standard_LRS", "64"]
    }
  }
}


variable "tfs" {
  default = {
    prefix             = "tfs" # lowercase letters only, for storage account naming
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
