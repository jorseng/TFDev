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

variable "gateway_virtual" {
  default = {
      name = ""
      type = ""
      vpn_type = ""
      sku = ""
      private_ip_allocation_method = ""
      #vpn_client_configuration = "" # for point to site
  }
}

variable "gw_subnet_id" {
  default = ""
}