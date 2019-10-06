resource "azurerm_availability_set" "as" {
  name                         = var.availability_set_profile.name
  location                     = var.resource_group.location
  resource_group_name          = var.resource_group.name
  platform_update_domain_count = var.availability_set_profile.platform_update_domain_count
  platform_fault_domain_count  = var.availability_set_profile.platform_fault_domain_count
  managed                      = var.availability_set_profile.managed
}

resource "azurerm_network_interface" "nic" {
  count               = var.vmcount
  name                = "${var.vm_profile.name}-${count.index + 1}-nic"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  ip_configuration {
    name                          = "${var.vm_profile.name}-${count.index + 1}-nic-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.vmcount
  name                  = "${var.vm_profile.name}-${count.index+1}"
  resource_group_name   = var.resource_group.name
  location              = var.resource_group.location
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size               = var.vm_profile.size

  delete_os_disk_on_termination    = false
  delete_data_disks_on_termination = false

  availability_set_id = azurerm_availability_set.as.id

  storage_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.offer
    sku       = var.os_image.sku
    version   = var.os_image.version
  }

  storage_os_disk {
    name              = "${var.vm_profile.name}-${count.index+1}-osdisk"
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