output "vnet" {
  value = {
    id                  = azurerm_virtual_network.vnet.id
    name                = azurerm_virtual_network.vnet.name
    address_space       = azurerm_virtual_network.vnet.address_space
    resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  }
}

output "subnets" {
  value = zipmap(azurerm_subnet.subnets.*.name, azurerm_subnet.subnets.*.id)
  # "Place all the subnets into zipmap with its corresponding name and id, to call the zipmap, requires lookup
  #  function, lookup(<collection>, <specify the key you are looking for, returns id>, <return this value if false>)"                
}

output "resource_group" {
  value = {
    name     = azurerm_virtual_network.vnet.resource_group_name
    location = azurerm_virtual_network.vnet.location
  }
}