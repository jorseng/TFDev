variable "resource_group" {
  default = {
      name = ""
      location =""
  }
}

variable "gw_pip" {
  default = {
      name = ""
      allocation_method = ""
  }
}

variable "gatewayVirtual" {
  default = {
      name = ""
      type = ""
      vpn_type = ""
      sku = ""
      #vpn_client_configuration = "" # for point to site
  }
}

variable "gw_subnet_id" {
  default = ""
}

variable "location" {
    default = ""
}

variable "resource_group_name" {
    default = ""
}