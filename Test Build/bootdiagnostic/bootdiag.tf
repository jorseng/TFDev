variable "boot_diagnostics" {
  default = "true"
}


provider "azurerm" {
    version = "1.27.1"  
}

resource "azurerm_resource_group" "hubrg" {
  name     = "bootdiagrg"
  location = "Southeast Asia"
}

# Storage Account
resource "azurerm_storage_account" "hub-diag-sa" {
  name                     = "bootdiaghubuse123456543"
  resource_group_name      = "${azurerm_resource_group.hubrg.name}"
  location                 = "${azurerm_resource_group.hubrg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Virtual Network 
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "hub-vnet"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "hub-subnet-services" {
  name                 = "hub-subnet-services"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "192.168.1.0/24"
}

resource "azurerm_network_interface" "azdc01-nic" {
  name                = "vm01-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "vm01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.hub-subnet-services.id}"
    private_ip_address            = "192.168.1.4"
    private_ip_address_allocation = "Static"
  }
}

# Virtual Machines
resource "azurerm_virtual_machine" "azdc01" {
  name                  = "vm01"
  resource_group_name   = "${azurerm_resource_group.hubrg.name}"
  location              = "${azurerm_resource_group.hubrg.location}"
  network_interface_ids = ["${azurerm_network_interface.azdc01-nic.id}"]
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

    boot_diagnostics {
      enabled     = "true"
      storage_uri = "${join(",", azurerm_storage_account.hub-diag-sa.*.primary_blob_endpoint)}"
      #storage_uri = "${var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.hub-diag-sa.*.primary_blob_endpoint) : "" }"
    }

}