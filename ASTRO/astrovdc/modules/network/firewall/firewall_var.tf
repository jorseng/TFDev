variable "resource_group" {
  default = {
    name = ""
    location = ""
  }
}

variable "fw_pip" {
  default = {
    name = ""
    allocation_method = ""
    sku = ""
  }
}

variable "firewall_name" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

