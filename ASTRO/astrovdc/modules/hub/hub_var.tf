
variable "resource_group" {
  default = {
    name = ""
    location = ""
  }
}

variable "virtual_network" {
  default = {
    name          = "hub"
    address_space = ["10.0.0.0/16"]
  }
}

variable "subnets" {
  default = {
    "dmz-subnet" = "10.0.1.0/24"
    "mgt-subnet" = "10.0.2.0/24"
    "svc-subnet" = "10.0.3.0/24"
    "sec-subnet" = "10.0.4.0/24"
  }
}
