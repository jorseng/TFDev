# Storage Account
resource "azurerm_storage_account" "hub-diag-sa" {
  name                     = "hubsafordiaguse"
  resource_group_name      = "${azurerm_resource_group.hubrg.name}"
  location                 = "${azurerm_resource_group.hubrg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

