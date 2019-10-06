##########################################################################
#   SUBSCRIPTIONS                                                       
##########################################################################

variable "Subscription" {
  default = {
    id = "5b98ba7c-c3f7-43ec-ac20-195d8109fe2b"
  }
}


##########################################################################
#   HUB                                                       
##########################################################################

variable "hub-network-rg" {
  default = {
    name     = "dev-network-rg"
    location = "southeastasia"
  }
}

variable "hub-vnet" {
  default = {
    name          = "dev-vnet"
    address_space = ["10.2.0.0/16"]
  }
}

variable "hub-subnets" {
  default = {
    "dmz-subnet" = "10.2.1.0/24"
    "mgt-subnet" = "10.2.2.0/24"
  }
}

variable "dev-transit-peering" {
  default = "dev-transit-peering"
}

variable "transit-dev-peering" {
  default = "transit-dev-peering"
}