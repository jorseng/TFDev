variable "resource_group" {
  default = {
    name     = ""
    location = ""
  }
}

variable "route_table_name" {
  default = ""
}

variable "routes" {
  description = "[address_prefix, next_hop_type]"
  default = {
    "" = ["", ""]
  }
}

variable "subnet_id_list" {
  default = [""]
}