##########################################################################
#   SUBSCRIPTIONS                                                       
##########################################################################

# variable "DevSubcription" {
#   default = {
#     id = "5b98ba7c-c3f7-43ec-ac20-195d8109fe2b"
#   }
# }

##########################################################################
#   RESOURCE GROUP                                                       
##########################################################################
variable "Dev-Network-RG" {
  default = {
    name     = "Dev-Network-RG"
    location = "southeastasia"
  }
}

variable "Dev-Security-RG" {
  default = {
    name     = "Dev-Security-RG"
    location = "southeastasia"
  }
}

variable "Dev-Management-RG" {
  default = {
    name     = "Dev-Management-RG"
    location = "southeastasia"
  }
}

##########################################################################
#   NETWORK
##########################################################################
################################ Vnet ####################################
variable "Dev-Vnet" {
  default = {
    name          = "Dev-Vnet"
    address_space = ["10.2.0.0/16"]
  }
}

variable "Spoke1-Vnet" {
  default = {
    name          = "Spoke1-Vnet"
    address_space = ["10.3.0.0/16"]
  }
}

################################ Subnet ##################################
variable "GatewaySubnet" {
  default = {
    name           = "GatewaySubnet"
    address_prefix = "10.2.255.224/27"
  }
}

variable "AzureFirewallSubnet" {
  default = {
    name           = "AzureFirewallSubnet"
    address_prefix = "10.2.0.0/26"
  }
}

variable "Dev-ExtWAF-Net01" {
  default = {
    name           = "Dev-ExtWAF-Net01"
    address_prefix = "10.2.0.64/26"
  }
}

variable "Dev-Net01" {
  default = {
    name           = "Dev-Net01"
    address_prefix = "10.2.1.0/24"
  }
}

variable "spoke1-subnet" {
  default = {
    name = "spoke1-subnet"
    address_prefix = "10.3.1.0/24"
  }
}


################################ S2S ##################################
variable "Dev-GW01-PIP01" {
  default = {
    name              = "Dev-GW01-PIP01"
    allocation_method = "Dynamic"
  }
}

variable "Dev-VPN-GW01" {
  default = {
    name     = "Dev-VPN-GW01"
    type     = "VPN"
    vpn_type = "RouteBased"
    sku      = "Standard"
  }
}

variable "Dev-Onprem-GW01" {
  default = {
    name            = "Dev-Onprem-GW01"
    gateway_address = "202.186.91.230"
    address_space   = "192.168.0.0/21"
  }
}

variable "s2sConnection" {
  default = {
    name       = "Dev-S2S-Connection"
    type       = "IPsec"
    shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  }
}


############################# ExpressRoute ###############################
variable "expressRoute" {
  default ={
      name = "Dev-ER-GW01"
      service_provider_name = "Time dotCom"
      peering_location = "Kuala Lumpur"
      bandwidth_in_mbps = 50
      sku_tier = "Standard"
      sku_family = "MeteredData"
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


#################### FIREWALL ##############################

variable "fw_pip" {
  default = {
    name = "fw-astro-test-pip"
    allocation_method = "Static"
    sku = "Standard"
  }
}

variable "firewall" {
  default = {
    name = "astro-fw-test"
    
  }
}
