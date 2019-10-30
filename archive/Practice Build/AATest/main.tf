resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.location
}


resource "azurerm_storage_account" "sa" {
  name                     = var.sa
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.subnet_address_prefix
}

resource "azurerm_public_ip" "pip" {
  name                = var.pip
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = var.ip_config
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address            = var.private_ip
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_virtual_machine" "vmAA" {
  name                  = var.vmAA
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]

  vm_size                          = "Standard_D2S_v3"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "vmAA-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vmAA
    admin_username = "DemoAdmin"
    admin_password = "DemoPassAdminW0rd"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${join(",", azurerm_storage_account.sa.*.primary_blob_endpoint)}"
  }
}


resource "azurerm_virtual_machine_extension" "dsc" {
  name                 = "AATestDsc"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_machine_name = azurerm_virtual_machine.vmAA.name
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"
  depends_on           = [azurerm_virtual_machine.vmAA]

  settings = <<SETTINGS
        {
            "WmfVersion": "latest",
            "Privacy": {
                "DataCollection": ""
            },
            "Properties": {
                "RegistrationKey": {
                  "UserName": "PLACEHOLDER_DONOTUSE",
                  "Password": "PrivateSettingsRef:registrationKeyPrivate"
                },
                "RegistrationUrl": "${azurerm_automation_account.azauto.dsc_server_endpoint}",
                "NodeConfigurationName": "${azurerm_automation_dsc_nodeconfiguration.dsc_nodeconfig.name}",
                "ConfigurationMode": "ApplyAndAutoCorrect",
                "ConfigurationModeFrequencyMins": 15,
                "RefreshFrequencyMins": 30,
                "RebootNodeIfNeeded": true,
                "ActionAfterReboot": "continueConfiguration",
                "AllowModuleOverwrite": false
            }
        }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Items": {
        "registrationKeyPrivate" : "${azurerm_automation_account.azauto.dsc_primary_access_key}"
      }
    }
PROTECTED_SETTINGS
}