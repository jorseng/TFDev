output "vnet" {
  value = {
    id            = azurerm_virtual_network.vnet.id
    name          = azurerm_virtual_network.vnet.name
    address_space = azurerm_virtual_network.vnet.address_space
    resource_group_name = azurerm_resource_group.rgroup.name
  }
}

output "resource_group" {
  value ={
    id = azurerm_resource_group.rgroup.id
    name = azurerm_resource_group.rgroup.name
    location = azurerm_resource_group.rgroup.location
  }
}

output "subnets" {
  value = zipmap(azurerm_subnet.subnets.*.name, azurerm_subnet.subnets.*.id)
  # "Place all the subnets into zipmap with its corresponding name and id, to call the zipmap, requires lookup
  #  function, lookup(<collection>, <specify the key you are looking for, returns id>, <return this value if false>)"                
}