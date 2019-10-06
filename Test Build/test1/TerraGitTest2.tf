# Configuring Azure provider
# DEMO TITLE: Test Readability from azure cli

# Resource Group
resource "azurerm_resource_group" "terratest_rg2" {
    name = "terratest_rg"
    location = "Southeast Asia"
}