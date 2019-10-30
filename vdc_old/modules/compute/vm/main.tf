resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_profile.name}-nic"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  ip_configuration {
    name                          = "${var.vm_profile.name}-nic-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_profile.name
  resource_group_name   = var.resource_group.name
  location              = var.resource_group.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_profile.size
  
  delete_os_disk_on_termination = false
  delete_data_disks_on_termination = false

  storage_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.offer
    sku       = var.os_image.sku
    version   = var.os_image.version
  }

  storage_os_disk {
    name              = "${var.vm_profile.name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    }

  os_profile {
    computer_name  = var.os_profile.hostname
    admin_username = var.os_profile.username
    admin_password = var.os_profile.password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

  boot_diagnostics {
    enabled     = var.boot_diagnostics.status
    storage_uri = var.boot_diagnostics.storage_uri
  }
}