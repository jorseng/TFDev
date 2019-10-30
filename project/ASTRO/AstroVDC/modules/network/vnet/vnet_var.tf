variable "resource_group" {
  default = {
    name     = "default-rg"
    location = "southeastasia"
  }
}

variable "virtual_network" {
  default = {
    name          = "hub"
    address_space = ["10.0.0.0/16"]
  }
}
