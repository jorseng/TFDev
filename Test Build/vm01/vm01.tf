locals {
  resource_group = "gcpMigration"
  location       = "Southeast Asia"
  vm_count       = 1
  vm_size        = "Standard_D2s_v3"
}

provider "azurerm" {
  version = "1.27.1"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group}"
  location = "${local.location}"
}

# Storage Account
resource "azurerm_storage_account" "diagstore" {
  name                     = "diagstoreuse"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Networking
resource "azurerm_virtual_network" "mainvnet" {
  name                = "${var.main_subnet_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${local.location}"
  address_space       = "${var.main_vnet_cidr}"
}

resource "azurerm_subnet" "mainsubnet" {
  name                 = "${var.main_subnet_name}"
  virtual_network_name = "${azurerm_virtual_network.mainvnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "${var.main_subnet_cidr}"
}

# PIP
resource "azurerm_public_ip" "pipList" {
  count               = "${local.vm_count}"
  name                = "${var.vm_prefix}-${count.index+1}-pip"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  allocation_method   = "Dynamic"
}

# NIC
resource "azurerm_network_interface" "vmnic" {
  count               = "${local.vm_count}"
  name                = "${var.vm_prefix}-${count.index+1}-nic"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"

  ip_configuration {
    name                          = "${var.vm_prefix}-${count.index}-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.mainsubnet.id}"
    private_ip_address            = "${var.vm_ip_prefix}${count.index+4}"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${element(azurerm_public_ip.pipList.*.id, count.index+1)}"
  }
}

# Compute

resource "azurerm_virtual_machine" "vmList" {
  count                 = "${local.vm_count}"
  name                  = "${var.vm_prefix}-${count.index+1}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  location              = "${azurerm_resource_group.rg.location}"
  network_interface_ids = ["${element(azurerm_network_interface.vmnic.*.id, count.index+1)}"]

  #network_interface_ids         = ["${azurerm_network_interface.app01-web02-nic.id}"]
  vm_size                       = "${local.vm_size}"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_prefix}-${count.index+1}-osdisk-${count.index+1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.vm_prefix}-${count.index+1}"
    admin_username = "DemoAdmin"
    admin_password = "DemoPassAdminW0rd"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${join(",", azurerm_storage_account.diagstore.*.primary_blob_endpoint)}"
  }
}





