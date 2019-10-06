resource "azurerm_network_interface" "vm_nic" {
  name                      = "${var.hostname}-nic"
  location                  = "${var.location}"
  resource_group_name       = "${var.rg_name}"
  network_security_group_id = "${var.nsg_id}"
  count                     = "${var.vm_count}"

  ip_configuration {
    name                          = "${var.hostname}-ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm_pip.*.id[count.index]}"
  }
}

resource "azurerm_public_ip" "vm_pip" {
  name                         = "${var.hostname}-pip-${random_id.namegen.hex}"
  location                     = "${var.location}"
  resource_group_name          = "${var.rg_name}"
  public_ip_address_allocation = "dynamic"
  count                        = "${var.vm_count}"
}

resource "azurerm_managed_disk" "managed_disk_data" {
  name                 = "${var.hostname}-${count.index + 1}-datadisk"
  location             = "${var.location}"
  resource_group_name  = "${var.rg_name}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "${var.data_disk_size}"
  count                = "${var.vm_count}"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.hostname}-${count.index + 1}"
  location              = "${var.location}"
  resource_group_name   = "${var.rg_name}"
  network_interface_ids = ["${azurerm_network_interface.vm_nic.*.id[count.index]}"]
  vm_size               = "${var.vm_size}"
  depends_on            = ["azurerm_public_ip.vm_pip"]
  count                 = "${var.vm_count}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "/subscriptions/xxxx/resourceGroups/rg-shared/providers/Microsoft.Compute/images/xx-image-xx"
  }

  storage_os_disk {
    name              = "myosdisk1${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  # Optional data disks

  storage_data_disk {
    name            = "${azurerm_managed_disk.managed_disk_data.*.name[count.index]}"
    managed_disk_id = "${azurerm_managed_disk.managed_disk_data.*.id[count.index]}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.managed_disk_data.*.disk_size_gb[count.index]}"
  }
}