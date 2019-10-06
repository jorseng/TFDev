provider "azurerm" {
    version ="1.27.1"  
}

# Resource Group
resource "azurerm_resource_group" "demorg" {
    name = "terra-appgw-rg"
    location = "Southeast Asia"
}

resource "azurerm_virtual_network" "vnet-appgw" {
    name = "vnet-appgw"
    location = "${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    address_space = ["192.168.0.0/16"]  
    #dns_servers = ["192.168.x.x"]
}

resource "azurerm_subnet" "frontend" {
    name = "subnet-appgw-frontend"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet-appgw.name}"
    address_prefix ="192.168.1.0/24"
}
resource "azurerm_subnet" "backend" {
    name = "subnet-appgw-backend"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet-appgw.name}"
    address_prefix ="192.168.2.0/24"
}

resource "azurerm_public_ip" "appgw-pip" {
    name = "appgw-pip"
    location = "${azurerm_resource_group.demorg.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    allocation_method = "Dynamic"
}

resource "azurerm_application_gateway" "appgw" {
    name = "appgw"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    location = "${azurerm_resource_group.demorg.location}"

    sku{
        name = "Standard_Small"
        tier ="Standard"
        capacity = 2
    }

    gateway_ip_configuration{
        name = "appgw-ip-config"
        subnet_id = "${azurerm_subnet.frontend.id}"
    }

    frontend_port{
        name = "appgw-frontend-port"
        port = 80
    }

    frontend_ip_configuration{
        name = "appgw-frontend-ip-config"
        public_ip_address_id = "${azurerm_public_ip.appgw-pip.id}"
    }

    backend_address_pool{
        name = "appgw-backend-address-pool"
        ip_addresses = ["192.168.1.4","192.168.1.5"]
    }
    # only the backend pool name is provisioned, the VM is not assigned
    
    backend_http_settings{
        name = "appgw-backend-http-settings"
        cookie_based_affinity = "Disabled"
        port = 80
        protocol = "Http"
        request_timeout = 1
    }

    http_listener{
        name = "appgw-http-listener"
        frontend_ip_configuration_name = "appgw-frontend-ip-config"
        frontend_port_name = "appgw-frontend-port"
        protocol = "Http"
    }

    request_routing_rule{
        name = "appgw-routing-rule"
        rule_type = "Basic"
        http_listener_name = "appgw-http-listener"
        backend_address_pool_name = "appgw-backend-address-pool"
        backend_http_settings_name = "appgw-backend-http-settings"
    }

}
