output "transit-vnet-id" {
  value = module.Transit-Hub.vnet.id
}

output "transit-vnet" {
  value = module.Transit-Hub.vnet
}

# output "transit-vpn-gateway" {
#   value = module.Transit-S2S-VPN.gateway_virtual
# }

# output "transit-vpn-pip" {
#   value = module.Transit-S2S-VPN.gateway_pip
# }

# output "transit-expressroute" {
#   value = module.Transit-ER.express_route
# }

# output "transit-firewall" {
#   value = module.Transit-FW01.firewall
# }