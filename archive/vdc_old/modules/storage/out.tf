# output "storage_account" {
#   value = {
#     name                  = azurerm_storage_account.sa.name
#     # fix the endpoint data types
#     primary_blob_endpoint = azurerm_storage_account.sa.*.primary_blob_endpoint
#   }
# }
