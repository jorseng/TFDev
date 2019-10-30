resource "azurerm_resource_group" "rg" {
  name     = "${var.virtual_machine.prefix}-test-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_machine.prefix}-test-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.virtual_machine.vnet_address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.virtual_machine.prefix}-test-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.virtual_machine.subnet_cidr
}


resource "azurerm_storage_account" "sa" {
  name                     = "${var.virtual_machine.prefix}teststorageaccountuse"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.virtual_machine.prefix}-test-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.virtual_machine.domain_name_label
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.virtual_machine.prefix}-test-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.virtual_machine.prefix}-nic-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = ""
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}


resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.virtual_machine.prefix}-test"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = var.virtual_machine.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.virtual_machine.prefix}-test-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.virtual_machine.managed_disk_type
  }

  # Optional data disks
  dynamic "storage_data_disk" {
    for_each = var.new_data_disk
    content {
      name              = "${var.virtual_machine.prefix}-test-data-disk-${storage_data_disk.key}"
      managed_disk_type = storage_data_disk.value[0]
      create_option     = "Empty"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value[1]
    }
  }

  dynamic "storage_data_disk" {
    for_each = var.attach_data_disk
    content {
      name            = storage_data_disk.value[0]
      managed_disk_id = storage_data_disk.value[1]
      create_option   = "Attach"
      lun             = storage_data_disk.key
      disk_size_gb    = storage_data_disk.value[2]
    }
  }

  os_profile {
    computer_name  = "${var.virtual_machine.prefix}-test"
    admin_username = var.virtual_machine.admin_username
    admin_password = var.virtual_machine.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
  }
}