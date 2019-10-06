# AZ DEMO

# Local Variables
locals{
    resource-group = "terra-vm-rg"
    vnet-app = "vnet-sea-app"
    vnet-app-subnet-webserver = "vnet-sea-app-subnet-webserver"
    vnet-app-subnet-dbserver = "vnet-sea-app-subnet-dbserver"
    webapp1 = "webapp1"
    webapp2 = "webapp2"
    dbserver = "dbserver"    
}



# Azure Provider ======================================================================================
provider "azurerm" {
    version ="1.27.1"  
}

# Resource Group ======================================================================================
resource "azurerm_resource_group" "demorg" {
    name = "${local.resource-group}"
    location = "Southeast Asia"
}

# Virtual Network ======================================================================================
resource "azurerm_virtual_network" "vnet-webapp" {
    name = "${local.vnet-app}"
    location = "${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    address_space = ["192.168.0.0/16"]
    #dns_servers = ["192.168.x.x"]
}

# Subnet ======================================================================================
resource "azurerm_subnet" "webserver" {
    name = "${local.vnet-app-subnet-webserver}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet-webapp.name}"
    address_prefix ="192.168.1.0/24"
}

resource "azurerm_subnet" "dbserver" {
    name = "${local.vnet-app-subnet-dbserver}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet-webapp.name}"
    address_prefix ="192.168.2.0/24"
}

# PIP ======================================================================================
resource "azurerm_public_ip" "webapp1-pip" {
    name = "${local.webapp1}-pip"
    location = "${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    allocation_method = "Dynamic"
}

# NIC ======================================================================================
resource "azurerm_network_interface" "webapp1-nic" {
    name = "${local.webapp1}-nic"
    location = "${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"

    ip_configuration {
        name = "${local.webapp1}-ipconfig"
        subnet_id = "${azurerm_subnet.webserver.id}"
        private_ip_address = "192.168.1.4"
        private_ip_address_allocation = "Static"
        public_ip_address_id = "${azurerm_public_ip.webapp1-pip.id}"
    }
}

resource "azurerm_network_interface" "webapp2-nic" {
    name = "${local.webapp2}-nic"
    location = "${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"

    ip_configuration {
        name = "${local.webapp2}-ipconfig"
        subnet_id = "${azurerm_subnet.webserver.id}"
        private_ip_address = "192.168.1.5"
        private_ip_address_allocation = "Static"
    }
}

# Availability Set ======================================================================================

resource "azurerm_availability_set" "webapp-as1" {
    name = "as01-demo-sea-webapp-prod"
    location = "${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    platform_fault_domain_count = 2
    platform_update_domain_count = 5
    managed = true
}

# Virtual Machines ======================================================================================
resource "azurerm_virtual_machine" "webapp1" {
    name = "${local.webapp1}"
    location ="${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    network_interface_ids = ["${azurerm_network_interface.webapp1-nic.id}"]
    vm_size = "Standard_D2s_v3"

    delete_os_disk_on_termination = true

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }

    storage_os_disk {
        name              = "${local.webapp1}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name = "${local.webapp1}"
        admin_username = "DemoAdmin"
        admin_password = "DemoPassAdminW0rd"
    }

    os_profile_windows_config{
        provision_vm_agent = true
        enable_automatic_upgrades = false
    }

    availability_set_id = "${azurerm_availability_set.webapp-as1.id}"
}

resource "azurerm_virtual_machine" "webapp2" {
    name = "${local.webapp2}"
    location ="${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    network_interface_ids = ["${azurerm_network_interface.webapp2-nic.id}"]
    vm_size = "Standard_D2s_v3"

    delete_os_disk_on_termination = true

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }

    storage_os_disk {
        name              = "${local.webapp2}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name = "${local.webapp2}"
        admin_username = "DemoAdmin"
        admin_password = "DemoPassAdminW0rd"
    }

    os_profile_windows_config{
        provision_vm_agent = true
        enable_automatic_upgrades = false
    }

    availability_set_id = "${azurerm_availability_set.webapp-as1.id}"
}

output "nic" {
    value = "test output",
    value = "${azurerm_virtual_machine.webapp1.name}"
}
