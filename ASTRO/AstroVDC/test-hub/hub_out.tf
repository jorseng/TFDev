output "Hub-vnet-id" {
  value = module.Prod-Hub.vnet.id
}

# output "Hub-vnet" {
#   value = module.Prod-Hub.vnet
# }

output "Hub-subnets" {
  value = module.Prod-Hub.subnets
}

# output "subnet" {
#   value       = lookup(module.Prod-Hub.subnets,"name")
# }

# output "Hub-vpn-gateway" {
#   value = module.Hub-S2S-VPN.gateway_virtual
# }

# output "Hub-vpn-pip" {
#   value = module.Hub-S2S-VPN.gateway_pip
# }

# output "Hub-expressroute" {
#   value = module.Hub-ER.express_route
# }

# output "Hub-Az-firewall" {
#   value = module.Hub-Az-FW01.firewall
# }