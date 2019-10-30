# Availability Set
resource "azurerm_availability_set" "azdc-as01" {
  name                         = "azdc-as01"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  location                     = "${azurerm_resource_group.hubrg.location}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true
}

resource "azurerm_availability_set" "app01-web-as01" {
  name                         = "app01-web-as01"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  location                     = "${azurerm_resource_group.hubrg.location}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true
}

# Virtual Machines
resource "azurerm_virtual_machine" "azdc01" {
  name                  = "azdc01"
  resource_group_name   = "${azurerm_resource_group.hubrg.name}"
  location              = "${azurerm_resource_group.hubrg.location}"
  network_interface_ids = ["${azurerm_network_interface.azdc01-nic.id}"]
  vm_size               = "Standard_D2s_v3"

  delete_os_disk_on_termination = true

  availability_set_id = "${azurerm_availability_set.azdc-as01.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "azdc01-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "azdc01"
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

resource "azurerm_virtual_machine" "azdc02" {
  name                  = "azdc02"
  resource_group_name   = "${azurerm_resource_group.hubrg.name}"
  location              = "${azurerm_resource_group.hubrg.location}"
  network_interface_ids = ["${azurerm_network_interface.azdc02-nic.id}"]
  vm_size               = "Standard_D2s_v3"
  depends_on            = ["azurerm_virtual_machine.azdc01"]

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "azdc02-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "azdc02"
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

  availability_set_id = "${azurerm_availability_set.azdc-as01.id}"
}

resource "azurerm_virtual_machine" "jumpserver01" {
  name                  = "jumpserver01"
  resource_group_name   = "${azurerm_resource_group.hubrg.name}"
  location              = "${azurerm_resource_group.hubrg.location}"
  network_interface_ids = ["${azurerm_network_interface.jumpserver01-nic.id}"]
  vm_size               = "Standard_D2s_v3"
  depends_on            = ["azurerm_virtual_machine.azdc01"]

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "jumpserver01-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpserver01"
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

resource "azurerm_virtual_machine" "app01-web01" {
  name                          = "app01-web01"
  resource_group_name           = "${azurerm_resource_group.hubrg.name}"
  location                      = "${azurerm_resource_group.hubrg.location}"
  network_interface_ids         = ["${azurerm_network_interface.app01-web01-nic.id}"]
  vm_size                       = "Standard_D2s_v3"
  depends_on                    = ["azurerm_virtual_machine.azdc01", "azurerm_virtual_network_peering.app01vnet-hubvnet", "azurerm_virtual_network_peering.hubvnet-app01vnet"]
  delete_os_disk_on_termination = true
  availability_set_id           = "${azurerm_availability_set.app01-web-as01.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "app01-web01-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "app01-web01"
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

resource "azurerm_virtual_machine" "app01-web02" {
  name                          = "app01-web02"
  resource_group_name           = "${azurerm_resource_group.hubrg.name}"
  location                      = "${azurerm_resource_group.hubrg.location}"
  network_interface_ids         = ["${azurerm_network_interface.app01-web02-nic.id}"]
  vm_size                       = "Standard_D2s_v3"
  depends_on                    = ["azurerm_virtual_machine.azdc01", "azurerm_virtual_network_peering.app01vnet-hubvnet", "azurerm_virtual_network_peering.hubvnet-app01vnet"]
  delete_os_disk_on_termination = true

  availability_set_id = "${azurerm_availability_set.app01-web-as01.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "app01-web02-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "app01-web02"
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
