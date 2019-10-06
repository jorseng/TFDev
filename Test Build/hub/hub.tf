# This section to create Hub
# This Hub includes:
# 1. Vnet
#     - 1 Hub VNet
# 2. Subnets
#     - Gateway Subnet
#     - Services Subnet (AD DNS, Azure monitor)
#     - Mgmt Subnet (Jumpbox)
# 3. Availability Set
#     - AD DNS x2 Set
# 2. VMs
#     - AD DNS1
#     - AD DNS2
#     - Jumpbox 
# 3. NIC
#     - AD DNS 1 NIC
#     - AD DNS 2 NIC
#     - Jumpbox NIC
# 4. Public IP 
#     - Jumpbox PIP
# 5. VM
#     - AD DNS 1
#     - AD DNS 2
#     - Jumpbox
# 6. Virtual Gateway
#     - Virtual Gateway
#     - UDR configuration
# 7. ScriptExtension
#     - Add AD Role
#     - Add DNS role
#     - Set Primary and Secondary DC
#     - Join servers to domain

provider "azurerm" {
  version = "1.27.1"
}

# Resource Group
resource "azurerm_resource_group" "hubrg" {
  name     = "hubrg"
  location = "Southeast Asia"
}

# Storage Account
resource "azurerm_storage_account" "hub-diag-sa" {
  name                     = "hubsafordiaguse"
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
  dns_servers         = ["192.168.3.4", "192.168.3.5"]
}

resource "azurerm_virtual_network" "app01-vnet" {
  name                = "app01-vnet"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["192.168.3.4", "192.168.3.5"]
}

# Vnet Peering
resource "azurerm_virtual_network_peering" "hubvnet-app01vnet" {
  name                         = "hubvnet-app01vnet"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name         = "${azurerm_virtual_network.hub-vnet.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.app01-vnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on                   = ["azurerm_virtual_network.app01-vnet", "azurerm_virtual_network.hub-vnet"]
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "app01vnet-hubvnet" {
  name                         = "app01vnet-hubvnet"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name         = "${azurerm_virtual_network.app01-vnet.name}"
  remote_virtual_network_id    = "${azurerm_virtual_network.hub-vnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  depends_on                   = ["azurerm_virtual_network.app01-vnet", "azurerm_virtual_network.hub-vnet"]
  use_remote_gateways = true
}

# Subnet
resource "azurerm_subnet" "hub-subnet-gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "192.168.1.0/24"
}

resource "azurerm_subnet" "hub-subnet-jumpbox" {
  name                 = "hub-subnet-jumpbox"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "192.168.2.0/24"
}

resource "azurerm_subnet" "hub-subnet-services" {
  name                 = "hub-subnet-services"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "192.168.3.0/24"
}

resource "azurerm_subnet" "app01-web-subnet" {
  name                 = "app01-web-subnet"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.app01-vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

# PIP
resource "azurerm_public_ip" "jumpserver01-pip" {
  name                = "jumpserver01-pip"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "gateway-pip" {
  name                = "gateway-pip"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  allocation_method   = "Dynamic"
}

# NIC
resource "azurerm_network_interface" "azdc01-nic" {
  name                = "azdc01-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "azdc01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.hub-subnet-services.id}"
    private_ip_address            = "192.168.3.4"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "azdc02-nic" {
  name                = "azdc02-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "azdc02-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.hub-subnet-services.id}"
    private_ip_address            = "192.168.3.5"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "jumpserver01-nic" {
  name                = "jumpserver01-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "jumpserver01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.hub-subnet-jumpbox.id}"
    private_ip_address            = "192.168.2.4"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${azurerm_public_ip.jumpserver01-pip.id}"
  }
}

resource "azurerm_network_interface" "app01-web01-nic" {
  name                = "app01-web01-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "app01-web01-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.app01-web-subnet.id}"
    private_ip_address            = "10.0.1.4"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_network_interface" "app01-web02-nic" {
  name                = "app01-web02-nic"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  ip_configuration {
    name                          = "app01-web02-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.app01-web-subnet.id}"
    private_ip_address            = "10.0.1.5"
    private_ip_address_allocation = "Static"
  }
}

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
  depends_on                    = ["azurerm_virtual_machine.azdc01"]
  delete_os_disk_on_termination = true
  availability_set_id = "${azurerm_availability_set.app01-web-as01.id}"
  
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
  depends_on                    = ["azurerm_virtual_machine.azdc01"]
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

#Sql Server
resource "azurerm_sql_server" "app01-sqlserver" {
  name                         = "app01-sqlserver"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  location                     = "${azurerm_resource_group.hubrg.location}"
  version                      = "12.0"
  administrator_login          = "DemoAdmin"
  administrator_login_password = "DemoPassAdminW0rd"
}

# SQL Server Firewall Rule assginment
resource "azurerm_sql_firewall_rule" "app01-sqlserver-fw-rule" {
  name                = "AllowAzureServices"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  server_name         = "${azurerm_sql_server.app01-sqlserver.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Database provisioning
resource "azurerm_sql_database" "app01-db01" {
  name                = "app01-db01"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  server_name         = "${azurerm_sql_server.app01-sqlserver.name}"
  edition             = "Standard"
}

# Virtual Gateway
resource "azurerm_virtual_network_gateway" "hub-gateway" {
  name                = "hub-gateway"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "hub-gateway-ipconfig"
    public_ip_address_id          = "${azurerm_public_ip.gateway-pip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.hub-subnet-gateway.id}"
  }
}

resource "azurerm_virtual_machine_extension" "azdc01-startup-script" {
  name                 = "install-adds-dns"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.azdc01.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on           = ["azurerm_virtual_machine.azdc01"]

  settings = <<SETTINGS
    { 
        "commandToExecute":"powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted; $SafeModeAdminPassword = ConvertTo-SecureString('DemoPassAdminW0rd') -AsPlainText -Force; set-timezone -Id 'Singapore Standard Time'; Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -ComputerName azdc01; Install-ADDSForest -DomainName 'azdemo.com' -DomainNetbiosName 'azdemo' -SafeModeAdministratorPassword $SafeModeAdminPassword -ForestMode Win2012R2 -DomainMode Win2012R2 -InstallDns -LogPath 'C:\\Windows\\NTDS' -SysvolPath 'C:\\Windows\\SYSVOL' -DatabasePath 'C:\\Windows\\NTDS' -NoRebootOnCompletion: $false -Force: $true;"
    }
    SETTINGS
}

resource "azurerm_virtual_machine_extension" "azdc02-startup-script" {
  name                 = "install-adds-dns"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.azdc02.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    { 
      "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/dc2_provisioning.ps1"],
      "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File dc2_provisioning.ps1"
    } 
    SETTINGS
}

resource "azurerm_virtual_machine_extension" "jumpserver01-startup-script" {
  name                 = "join-domain"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.jumpserver01.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    { 
      "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/joindomain.ps1"],
      "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File joindomain.ps1"
    }
    SETTINGS
}

# App01-web01
resource "azurerm_virtual_machine_extension" "iis1" {
  name                 = "install-iis1"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.app01-web01.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"


  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/app01web01.ps1"],
      "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File app01web01.ps1"
    }
    SETTINGS
}


resource "azurerm_virtual_machine_extension" "iis2" {
  name                 = "install-iis2"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.app01-web02.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"


  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/app01web02.ps1"],
      "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File app01web02.ps1"
    }
    SETTINGS
}

