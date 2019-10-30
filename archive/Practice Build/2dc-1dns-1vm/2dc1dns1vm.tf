# Environment
# Vnet need to use custom dns.
# 1. dc01
# 2. dc02
# 3. vm01
# Automate: 
#     dc01 - primary dc, dns (create new forest, dns, dns forwarding zone)
#     dc02 - secondary dc
#     vm01 - join domain


provider "azurerm" {
    version ="1.27.1"  
}
# Resource Group
resource "azurerm_resource_group" "hubrg" {
    name        = "hubrg"
    location    ="Southeast Asia"
}

# Virtual Network 
resource "azurerm_virtual_network" "hub-vnet" {
    name = "hub-vnet"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    location = "${azurerm_resource_group.hubrg.location}"
    address_space = ["192.168.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "hub-subnet" {
    name = "hub-subnet"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
    address_prefix = "192.168.1.0/24"
}

# PIP
resource "azurerm_public_ip" "dc01-pip" {    
    name = "dc01-pip"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    location = "${azurerm_resource_group.hubrg.location}"
    allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "dc02-pip" {
    name = "dc02-pip"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    location = "${azurerm_resource_group.hubrg.location}"
    allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "vm01-pip" {
    name = "vm01-pip"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    location = "${azurerm_resource_group.hubrg.location}"
    allocation_method = "Dynamic"
}

# NIC

resource "azurerm_network_interface" "dc01-nic" {
    name = "dc01-nic"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    location = "${azurerm_resource_group.hubrg.location}"

    ip_configuration{
        name = "dc01-nic-ipconfig"
        subnet_id = "${azurerm_subnet.hub-subnet-services.id}"
        private_ip_address = "192.168.1.4"
        private_ip_address_allocation = "Static"
        public_ip_address_id = "${azurerm_public_ip.dc01-pip.id}"
    }
}

resource "azurerm_network_interface" "azdc02-nic" {
    name = "azdc02-nic"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    location = "${azurerm_resource_group.hubrg.location}"

    ip_configuration{
        name = "azdc02-nic-ipconfig"
        subnet_id = "${azurerm_subnet.hub-subnet-services.id}"
        private_ip_address = "192.168.1.5"
        private_ip_address_allocation = "Static"
        public_ip_address_id = "${azurerm_public_ip.dc02-pip.id}"
    }
}

resource "azurerm_network_interface" "jumpserver01-nic" {
    name = "jumpserver01-nic"
    resource_group_name = "${azurerm_resource_group.hubrg.name}"
    location = "${azurerm_resource_group.hubrg.location}"

    ip_configuration{
        name = "jumpserver01-nic-ipconfig"
        subnet_id = "${azurerm_subnet.hub-subnet-jumpbox.id}"
        private_ip_address = "192.168.1.6"
        private_ip_address_allocation = "Static"
        public_ip_address_id = "${azurerm_public_ip.vm01-pip.id}"
    }
}





# ExtensionScript
resource "azurerm_virtual_machine_extension" "iis" {
    name                 = "install-iis"
    resource_group_name  = "${azurerm_resource_group.hubrg.name}"
    location             = "${azurerm_resource_group.hubrg.location}"
    virtual_machine_name = "${azurerm_virtual_machine.dc01.name}"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.9"
    settings = <<SETTINGS
    { 
        "commandToExecute":"powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted;Invoke-Expression ((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/jorseng/TFDev/master/hub/test.ps1"));"
    } 
    SETTINGS
}