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
      sku = ""
  }
}

variable "gateway_virtual" {
  default = {
      name = ""
      type = ""
      vpn_type = ""
      sku = ""
      private_ip_allocation_method = ""
      active_active = "false"
      enable_bgp = "false"
  }
}

variable "gw_subnet_id" {
  default = ""
}

variable "gateway_local" {
  default = {
    name = ""
    gateway_address =""
    address_space = ""
  }
}

variable "s2s_connection" {
  default = {
    name = ""
    type = ""
    shared_key = ""
  }
}