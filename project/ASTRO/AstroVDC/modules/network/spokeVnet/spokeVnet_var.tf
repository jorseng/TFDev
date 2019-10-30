variable "resource_group" {
  default = {
    name     = "default-rg"
    location = "southeastasia"
  }
}

variable "virtual_network" {
  default = {
    name          = ""
    address_space = ["100.0.0.0/16"]
  }
}

variable "subnets" {
  default = {
    "dmz-subnet" = "100.0.1.0/24"
    "mgt-subnet" = "100.0.2.0/24"
  }
}

variable "spoke_vnet_peering" {
  default = {
    name                         = ""
    allow_virtual_network_access = "false"
    allow_forwarded_traffic      = "false"
    allow_gateway_transit       = "false"
    use_remote_gateways          = "true"
  }
}

variable "hub_vnet_peering" {
  default = {
    name                         = ""
    allow_virtual_network_access = "false"
    allow_forwarded_traffic      = "false"
    allow_gateway_transit       = "true"
    use_remote_gateways          = "false"
  }
}

variable "hub_vnet" {
  default = {
    id                  = ""
    name                = ""
    resource_group_name = ""
  }
}

