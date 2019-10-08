variable "resource_group" {
  default = {
    name     = "default-rg"
    location = "southeastasia"
  }
}

variable "virtual_network" {
    default = {
        name = ""
    }
}

variable "subnet" {
  default = {
    name          = "subnet"
    address_prefix = "10.1.0.0/24"
  }
}

variable "nsg_id" {
  default     = 
}