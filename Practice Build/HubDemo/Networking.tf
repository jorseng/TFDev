# Virtual Network 
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "hub-vnet"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  address_space       = ["192.168.0.0/16"]
  dns_servers         = ["192.168.3.4", "192.168.3.5"]
}

resource "azurerm_virtual_network" "app01-vnet" {
  name                = "app01-vnet"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["192.168.3.4", "192.168.3.5"]
}

# Vnet Peering
resource "azurerm_virtual_network_peering" "hubvnet-app01vnet" {
  name                         = "hubvnet-app01vnet"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name         = "${azurerm_virtual_network.hub-vnet.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.app01-vnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on                   = ["azurerm_virtual_network.app01-vnet", "azurerm_virtual_network.hub-vnet"]
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "app01vnet-hubvnet" {
  name                         = "app01vnet-hubvnet"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name         = "${azurerm_virtual_network.app01-vnet.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.hub-vnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on                   = ["azurerm_virtual_network.app01-vnet", "azurerm_virtual_network.hub-vnet"]
  use_remote_gateways          = true
}

# Subnet
resource "azurerm_subnet" "hub-subnet-gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "192.168.1.0/24"
}

resource "azurerm_subnet" "hub-subnet-jumpbox" {
  name                 = "hub-subnet-jumpbox"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "192.168.2.0/24"
}

resource "azurerm_subnet" "hub-subnet-services" {
  name                 = "hub-subnet-services"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "192.168.3.0/24"
}

resource "azurerm_subnet" "app01-web-subnet" {
  name                 = "app01-web-subnet"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.app01-vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

# PIP
resource "azurerm_public_ip" "jumpserver01-pip" {
  name                = "jumpserver01-pip"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "gateway-pip" {
  name                = "gateway-pip"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  allocation_method   = "Dynamic"
}

# NIC
resource "azurerm_network_interface" "azdc01-nic" {
  name                = "azdc01-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "azdc01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.hub-subnet-services.id}"
    private_ip_address            = "192.168.3.4"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "azdc02-nic" {
  name                = "azdc02-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "azdc02-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.hub-subnet-services.id}"
    private_ip_address            = "192.168.3.5"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "jumpserver01-nic" {
  name                = "jumpserver01-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "jumpserver01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.hub-subnet-jumpbox.id}"
    private_ip_address            = "192.168.2.4"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${azurerm_public_ip.jumpserver01-pip.id}"
  }
}

resource "azurerm_network_interface" "app01-web01-nic" {
  name                = "app01-web01-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "app01-web01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.app01-web-subnet.id}"
    private_ip_address            = "10.0.1.4"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "app01-web02-nic" {
  name                = "app01-web02-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "app01-web02-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.app01-web-subnet.id}"
    private_ip_address            = "10.0.1.5"
    private_ip_address_allocation = "Static"
  }
}

# Virtual Gateway
resource "azurerm_virtual_network_gateway" "hub-gateway" {
  name                = "hub-gateway"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "hub-gateway-ipconfig"
    public_ip_address_id          = "${azurerm_public_ip.gateway-pip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.hub-subnet-gateway.id}"
  }
}
