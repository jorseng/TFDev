# locals {
#   nic_list = [""]
# }

# resource "azurerm_public_ip" "pip" {
#   name = 
#   location = 
#   resource_group_name = 
#   allocation_method = 
#   sku = 
#   domain_name_label =
# }

# resource "azurerm_network_interface" "nic" {
#   for_each = var.virtual_machine.nic
#   name                = "${var.virtual_machine.name}-Nic-${each.key}"
#   location            = var.resource_group.location
#   resource_group_name = var.resource_group.name

#   dynamic "ip_configuration" {
#     count = length(var.virtual_machine.nic[each.key].value[1])
#     content{
#       name = "${var.virtual_machine.name}-Nic-${each.key}-Ipconfig-${count.index}"
#       subnet_id = var.subnet_id
#       private_ip_address_allocation = ip_configuration.
#       public_ip_address_id
#     }
#   }

#   ip_configuration {
#     #name                          = "${var.virtual_machine.name}-Nic-${count.index}-Ipconfig"
#     name                          = "${var.virtual_machine.name}-Nic-1-Ipconfig-1"
#     subnet_id                     = var.subnet_id
#     private_ip_address_allocation = var.virtual_machine.private_ip_allocation
#     private_ip_address            = var.virtual_machine.private_ip_address
#   }
# }
#################################################################################

resource "azurerm_network_interface" "nic" {
  name                = "${var.virtual_machine.name}-Nic-1"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "${var.virtual_machine.name}-Nic-1-Ipconfig-1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.virtual_machine.private_ip_allocation
    private_ip_address            = var.virtual_machine.private_ip_address
    public_ip_address_id          = var.pip_id
  }
}


resource "azurerm_virtual_machine" "vm" {
  name                  = var.virtual_machine.name
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = var.virtual_machine.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    id = var.image_reference_id
  }

  # plan {
  #   name      = "2016-Datacenter"
  #   publisher = "MicrosoftWindowsServer"
  #   product   = "WindowsServer"
  # }

  plan {
    name      = "cis-ws2016-l1" # Sku
    publisher = "center-for-internet-security-inc"
    product   = "cis-windows-server-2016-v1-0-0-l1" # Offer ID
  }

  storage_os_disk {
    name              = "${var.virtual_machine.name}-OS-Disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.virtual_machine.managed_disk_type
  }

  # Optional data disks

  dynamic "storage_data_disk" {
    for_each = var.new_data_disk
    content {
      name              = "${var.virtual_machine.name}-Data-Disk-${storage_data_disk.key}"
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
    computer_name  = var.virtual_machine.host_name
    admin_username = var.virtual_machine.admin_username
    admin_password = var.virtual_machine.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

    boot_diagnostics {
    enabled     = "true"
    storage_uri = var.storage_uri
  }
}