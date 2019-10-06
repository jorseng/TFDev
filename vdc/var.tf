##########################################################################
#   RESOURCE GROUP                                                       
##########################################################################
variable "rgroup" {
  default = {
    count    = 2
    name     = "testterra-rg"
    location = "southeastasia"
  }
}

##########################################################################
#   NETWORK
##########################################################################

variable "vnet" {
  default = {
    name          = "main-vnet"
    address_space = ["10.1.0.0/16"]
  }
}

variable "subnets" {

  default = {
    #"dmz-subnet" = "10.1.1.0/24"
    "mgt-subnet" = "10.1.2.0/24"
    #"test-subnet" = "10.1.3.0/24"
  }
}

##########################################################################
#   VIRTUAL MACHINES
##########################################################################

variable "vm_profile" {
  default = {
    name = "webserver"
    size = "Standard_D2s_v3"
  }
}

variable "os_profile" {
  default = {
    hostname = "webserver"
    username = "DemoAdmin"
    password = "DemoPassAdminW0rd"
  }
}

variable "os_image" {
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "boot_diagnostics" {
  default = {
    status      = "false"
    storage_uri = ""
    #storage_uri = "${join(",", azurerm_storage_account.diagstore.*.primary_blob_endpoint)}"
  }
}


##########################################################################
#   AVAILABILITY SET PROFILE
##########################################################################
variable "vmcount" {
  default = 3
}

variable "webserver_set_profile" {
  default = {
    name                         = "webserver-as1"
    platform_update_domain_count = 5
    platform_fault_domain_count  = 2
    managed                      = true
  }
}