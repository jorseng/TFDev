provider "azurerm" {
  version = "1.27.1"
}

# Resource Group
resource "azurerm_resource_group" "hubrg" {
  name     = "hubrg"
  location = "Southeast Asia"
}


