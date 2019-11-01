resource "azurerm_resource_group" "rg" {
  name     = "${var.vmset.prefix}-test-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vmset.prefix}-test-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.vmset.vnet_address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.vmset.prefix}-test-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.vmset.subnet_cidr
}


resource "azurerm_storage_account" "sa" {
  name                     = "${var.vmset.prefix}teststorageaccountuse"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_public_ip" "pip" {
  for_each            = var.vmset.vms
  name                = "${var.vmset.prefix}-${each.key}-test-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.vmset.prefix}-${each.key}-test"
}

output "pip" {
  value       = zipmap(azurerm_public_ip.pip.*.name,azurerm_public_ip.pip.*.id)
}

/*
resource "azurerm_network_interface" "nic" {
  for_each            = var.vmset.vms
  name                = "${var.vmset.prefix}-${each.key}-test-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.vmset.prefix}-${each.key}-test-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = ""
    public_ip_address_id          = lookup(azurerm_public_ip.pip.*.name, "${var.vmset.prefix}-${each.key}-test-pip", azurerm_public_ip.pip.*.id)
  }
}
*/

/*
resource "azurerm_virtual_machine" "vm" {
  for_each              = var.vmset.vms
  name                  = "${var.vmset.prefix}-${each.key}-test"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  #network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  #["${element(azurerm_network_interface.vmnic.*.id, count.index+1)}"]

  network_interface_ids = [lookup(azurerm_network_interface.nic.*.name, "${var.vmset.prefix}-${each.key}-test-nic", azurerm_network_interface.nic.*.id)]
  vm_size               = each.value[0]

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
    name              = "${var.vmset.prefix}-${each.key}-test-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = each.value[1]
    disk_size_gb      = each.value[2]
  }

  os_profile {
    computer_name  = "${var.vmset.prefix}-test"
    admin_username = var.vmset.admin_username
    admin_password = var.vmset.admin_password
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


*/