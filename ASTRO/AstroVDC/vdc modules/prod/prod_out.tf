# output "dev-vnet-id" {
#   value = module.Dev-Vnet-Spoke.vnet.id
# }

# output "dev-vnet" {
#   value       = module.Dev-Vnet-Spoke.vnet
# }

output "prodvmbootdiagsa" {
  description = "storage account for vm boot diagnostics in prod subscription"
  value       = module.prodvmbootdiagsa.storage_account
}
