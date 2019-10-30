output "subnet" {
    value = {
        id = azurerm_subnet.subnet.id
        name = azurerm_subnet.subnet.name
        address_prefix = azurerm_subnet.subnet.address_prefix
        virtual_network_name = azurerm_subnet.subnet.virtual_network_name
    }
}
