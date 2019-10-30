##########################################################################
#   LOG ANALYTICS                                                       
##########################################################################

variable "Prod-Monitor-RG" {
  default = {
    name     = "Prod-Monitor-RG"
    location = "southeastasia"
  }
}

variable "Prod-LAW-01" {
  description = "Log analytics"
  default = {
    name = "Prod-LAW-01"
    sku  = "PerGB2018"
  }
}

##########################################################################
#   BOOT DIAGNOSTIC STORAGE ACCOUNT                                                       
##########################################################################

variable "Prod-Mgmt-RG" {
  default = {
    name     = "Prod-Mgmt-RG"
    location = "southeastasia"
  }
}

variable "prodvmbootdiagsa" {
  default = {
    name                     = "prodvmbootdiagsa"
    account_tier             = "Standard" #Standard
    account_replication_type = "LRS"      #LRS
  }
}