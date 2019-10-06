locals {
  location = "Southeast Asia"
  vnet1    = "testpeering-vnet-1"
  vnet2    = "testpeering-vnet-2"
  subnet1  = "${local.vnet1}-subnet1"
  subnet2  = "${local.vnet2}-subnet2"
}

provider "azurerm" {
  version = "1.27.1"
}

# Resource Group
resource "azurerm_resource_group" "peeringrg" {
  name     = "peeringrg"
  location = "${local.location}"
}

# Virtual Network 
resource "azurerm_virtual_network" "vnet1" {
  name                = "${local.vnet1}"
  resource_group_name = "${azurerm_resource_group.peeringrg.name}"
  location            = "${azurerm_resource_group.peeringrg.location}"
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "${local.vnet2}"
  resource_group_name = "${azurerm_resource_group.peeringrg.name}"
  location            = "${azurerm_resource_group.peeringrg.location}"
  address_space       = ["192.169.0.0/16"]
}

resource "azurerm_virtual_network_peering" "vnet1-vnet2" {
  name                         = "vnet1-vnet2"
  resource_group_name          = "${azurerm_resource_group.peeringrg.name}"
  virtual_network_name         = "${azurerm_virtual_network.vnet1.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.vnet2.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "vnet2-vnet1" {
  name                         = "vnet2-vnet1"
  resource_group_name          = "${azurerm_resource_group.peeringrg.name}"
  virtual_network_name         = "${azurerm_virtual_network.vnet2.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.vnet1.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Subnet
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.peeringrg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
  address_prefix       = "192.168.1.0/24"
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = "${azurerm_resource_group.peeringrg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet2.name}"
  address_prefix       = "192.169.1.0/24"
}

resource "azurerm_public_ip" "vm01-pip" {
  name                = "vm01-pip"
  resource_group_name = "${azurerm_resource_group.peeringrg.name}"
  location            = "${azurerm_resource_group.peeringrg.location}"
  allocation_method   = "Dynamic"
}

# NIC
resource "azurerm_network_interface" "vm01-nic" {
  name                = "vm01-nic"
  resource_group_name = "${azurerm_resource_group.peeringrg.name}"
  location            = "${azurerm_resource_group.peeringrg.location}"

  ip_configuration {
    name                          = "vm01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address            = "192.168.1.4"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${azurerm_public_ip.vm01-pip.id}"
  }
}

resource "azurerm_network_interface" "vm02-nic" {
  name                = "vm02-nic"
  resource_group_name = "${azurerm_resource_group.peeringrg.name}"
  location            = "${azurerm_resource_group.peeringrg.location}"

  ip_configuration {
    name                          = "vm02-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet2.id}"
    private_ip_address            = "192.169.1.4"
    private_ip_address_allocation = "Static"
  }
}

# VM

resource "azurerm_virtual_machine" "vm01" {
  name                  = "vm01"
  resource_group_name   = "${azurerm_resource_group.peeringrg.name}"
  location              = "${azurerm_resource_group.peeringrg.location}"
  network_interface_ids = ["${azurerm_network_interface.vm01-nic.id}"]
  vm_size               = "Standard_D2s_v3"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "vm01-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm01"
    admin_username = "DemoAdmin"
    admin_password = "DemoPassAdminW0rd"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }
}

resource "azurerm_virtual_machine" "vm02" {
  name                  = "vm02"
  resource_group_name   = "${azurerm_resource_group.peeringrg.name}"
  location              = "${azurerm_resource_group.peeringrg.location}"
  network_interface_ids = ["${azurerm_network_interface.vm02-nic.id}"]
  vm_size               = "Standard_D2s_v3"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "vm02-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm02"
    admin_username = "DemoAdmin"
    admin_password = "DemoPassAdminW0rd"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }
}
