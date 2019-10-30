/*
provider
resource group
storage account
virtual network
Subnet
Public IP
Network interface
Virtual Machine
*/

locals {
  rgname       = "jstestrg"
  locationName = "Southeast Asia"
}


provider "azurerm" {
  version = "1.28.0"
}

// Resource group
resource "azurerm_resource_group" "rg" {
  name     = local.rgname
  location = local.locationName
}

// Storage account
resource "azurerm_storage_account" "sa" {
  name                     = "jsterraworkshop"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



// Virtual Network

resource "azurerm_virtual_network" "mainvnet" {
  name                = "jstest-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

// subnet
resource "azurerm_subnet" "subnet1" {
  name                 = "sharedservice-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.mainvnet.name
  address_prefix       = "10.0.1.0/24"
}

// Public IP
resource "azurerm_public_ip" "pip1" {
  name                = "vm-pip1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

// NIC
resource "azurerm_network_interface" "nic1" {
  name                = "vm-nic1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "vm-ipconfig"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address            = "10.0.1.5"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.pip1.id

  }
}


// Virtual Machine
resource "azurerm_virtual_machine" "vm1" {
  name                  = "jsvm01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  #delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "vm1-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "jsvm01"
    admin_username = "DemoAdmin"
    admin_password = "DemoPassAdminW0rd"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = join(",", azurerm_storage_account.sa.*.primary_blob_endpoint)
  }

}