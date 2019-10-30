resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account.name
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = var.storage_account.tier
  account_replication_type = var.storage_account.replication_type
}
