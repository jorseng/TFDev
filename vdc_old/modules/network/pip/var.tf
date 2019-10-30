variable "resource_group" {
  default = {
      name = ""
      location = ""
  }
}

variable "pip" {
  default = {
      name = "default-pip-name"
      allocation_method = "Dynamic"
  }
}
