resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account.name
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = var.storage_account.account_tier
  account_replication_type = var.storage_account.account_replication_type
}
