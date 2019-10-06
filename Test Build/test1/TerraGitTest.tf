# Configuring Azure provider
# DEMO TITLE: Test Readability from azure cli


provider "azurerm" {
    version ="1.27.1"  
}

# Resource Group
resource "azurerm_resource_group" "terratest_rg1" {
    name = "terratest_rg"
    location = "Southeast Asia"
}