# Configuring Azure provider
# DEMO TITLE: Create and deploy WebApp on IIS using Terraform on Azure.


provider "azurerm" {
    version ="1.27.1"  
}

# Resource Group
resource "azurerm_resource_group" "terratest_rg" {
    name = "terratest_rg"
    location = "Southeast Asia"
}


# VNet
resource "azurerm_virtual_network" "terratest_vnet" {
    name = "terratest_vnet"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
    location = "${azurerm_resource_group.terratest_rg.location}"
    address_space = ["10.0.0.0/16"]
}


# Subnet
resource "azurerm_subnet" "terratest_subnet" {
    name = "terratest_subnet"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
    virtual_network_name = "${azurerm_virtual_network.terratest_vnet.name}"
    address_prefix = "10.0.1.0/24"
    # requires microsoft.sql service endpoint
}

# Public IP
resource "azurerm_public_ip" "terratest-pip" {
    name = "terratest-pip"
    location = "${azurerm_resource_group.terratest_rg.location}"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
    allocation_method = "Dynamic"
}

# NIC
resource "azurerm_network_interface" "terratest-nic" {
    name = "terratest-nic"
    location = "${azurerm_resource_group.terratest_rg.location}"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"

    ip_configuration {
        name = "terratest-ipconfig"
        subnet_id = "${azurerm_subnet.terratest_subnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = "${azurerm_public_ip.terratest-pip.id}"
    }
}

# NSG
resource "azurerm_network_security_group" "terratest-nsg" {
    name = "terratest-nsg"
    location = "${azurerm_resource_group.terratest_rg.location}"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"

    security_rule {
        name = "terratest-nsg-rule-rdp"
        priority = 1000
        direction = "Inbound"
        access = "Allow"
        protocol = "TCP"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# NSG Association
resource "azurerm_subnet_network_security_group_association" "terratest-nsg-association" {
    subnet_id = "${azurerm_subnet.terratest_subnet.id}"  
    network_security_group_id = "${azurerm_network_security_group.terratest-nsg.id}"
}



# # Managed Disk
# resource "azurerm_managed_disk" "terratest-disk" {
#     name = "terratest-disk"
#     location = "${azurerm_resource_group.terratest_rg.location}"
#     resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
#     storage_account_type = "Standard_LRS"
#     create_option = "Empty"
#     disk_size_gb = "1"
# }


# Compute Provisioning
resource "azurerm_virtual_machine" "terratest-vm" {
    name = "terratest-vm"
    location = "${azurerm_resource_group.terratest_rg.location}"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
    network_interface_ids = ["${azurerm_network_interface.terratest-nic.id}"]
    vm_size = "Standard_D4_v3"

    # delete_data_disks_on_termination = true
    delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

    storage_os_disk {
    name              = "terratest-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

    os_profile {
        computer_name = "terratest"
        admin_username = "jorseng"
        admin_password = "jorPasssengw0rd"
    }

    os_profile_windows_config{
        provision_vm_agent = true
        enable_automatic_upgrades = false
    }
}

# SQL Server Provisioning
resource "azurerm_sql_server" "terratest-sql-server" {
    name = "terratest-sql-server"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
    location = "${azurerm_resource_group.terratest_rg.location}"
    version = "12.0"
    administrator_login = "jorseng"
    administrator_login_password = "jorPasssengw0rd"  
}

# SQL Server Firewall Rule assginment
# NOTE: Does not seem to be applied in the sql server, yet App server still can connect to db
resource "azurerm_sql_firewall_rule" "terratest-sql-server-fw-rule" {
    name = "AllowAzureServices"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
    server_name = "${azurerm_sql_server.terratest-sql-server.name}"
    start_ip_address = "0.0.0.0"
    end_ip_address = "0.0.0.0"
}

# Database provisioning
resource "azurerm_sql_database" "terratest-sqldb" {
    name = "terratest-sqldb"
    resource_group_name = "${azurerm_resource_group.terratest_rg.name}"
    location = "${azurerm_resource_group.terratest_rg.location}"
    server_name = "${azurerm_sql_server.terratest-sql-server.name}"
    edition = "Standard"
}


# Startup Configuration Powershell
# https://github.com/ghostinthewires/terraform-azurerm-iis-install/blob/master/main.tf
resource "azurerm_virtual_machine_extension" "iis" {
    name                 = "install-iis"
    resource_group_name  = "${azurerm_resource_group.terratest_rg.name}"
    location             = "${azurerm_resource_group.terratest_rg.location}"
    virtual_machine_name = "${azurerm_virtual_machine.terratest-vm.name}"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.9"
    settings = <<SETTINGS
    {
        "commandToExecute":"powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted;mkdir C:\\source;wget https://webformapp.blob.core.windows.net/webformappcontainer/WebFormApp.zip -outfile C:\\source\\WebFormApp.zip;Expand-Archive C:\\source\\WebFormApp.zip -DestinationPath C:\\source;C:\\source\\InitializationScript.ps1;"
    }
    SETTINGS
}
