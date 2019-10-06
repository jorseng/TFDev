variable "resource_group" {
  default = {
    name     = "default-rg"
    location = "southeastasia"
  }
}

variable "virtual_network" {
  default = {
    name          = ""
    address_space = ["10.0.0.0/16"]
  }
}

variable "subnets" {
  default = {
    "dmz-subnet" = "10.0.1.0/24"
    "mgt-subnet" = "10.0.2.0/24"
  }
}


variable "local_vnet_peering_name" {
  default     = ""
}

variable "remote_vnet_peering_name" {
  default     = ""
}

variable "remote_vnet" {
  default = {
    id = ""
    name = ""
    resource_group_name = ""
  }
}


