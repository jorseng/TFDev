variable "resource_group" {
  name     = ""
  location = ""
}

variable "storage_account" {
  default = {
    name             = "defaultuniquename"
    tier             = "Standard"
    replication_type = "LRS"
  }
}
