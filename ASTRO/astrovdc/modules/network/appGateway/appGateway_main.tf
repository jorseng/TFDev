resource "azurerm_public_ip" "appgwPip" {
  name                = var.appgw_pip.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = var.appgw_pip.allocation_method
}

# Backend pool can have "multiple pool" and each pool can have "multiple targets"
# "Multiple Routing rules" and each with settings and "multiple path based routing"

resource "azurerm_application_gateway" "appgw" {
  name                = var.application_gateway_config.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  sku {
    name     = var.application_gateway_config.sku_type
    tier     = var.application_gateway_config.sku_tier
    capacity = var.application_gateway_config.sku_capacity
  }

  gateway_ip_configuration {
    name      = "${var.application_gateway_config.name}-IP-Config"
    subnet_id = var.appgw_subnet_id
  }

  frontend_port {
    name = var.application_gateway_config.fe_port_name
    port = var.application_gateway_config.fe_port
  }

  frontend_ip_configuration {
    name = "${var.application_gateway_config.fe_port_name}-Ip-Config"
    public_ip_address_id = azurerm_public_ip.appgwPip.id
  }

  dynamic "backend_address_pool" {
    for_each = var.application_gateway_config.be_pool
    content {
      name         = backend_address_pool.key
      ip_addresses = backend_address_pool.value
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.application_gateway_config.be_http_settings
    content {
      name                  = backend_http_settings.key
      cookie_based_affinity = backend_http_settings.value[0]
      protocol              = backend_http_settings.value[1]
      port                  = backend_http_settings.value[2]
      request_timeout       = backend_http_settings.value[3]
      # path contains more settings: path, path name, listener, http setting
      path = backend_http_settings.value[4] # incomplete setting, placeholder for now
    }
  }

  dynamic "http_listener" {
    for_each = var.application_gateway_config.routing_rule
    content {
      name                           = http_listener.value[3]
      protocol                       = http_listener.value[4]
      frontend_ip_configuration_name = "${var.application_gateway_config.fe_port_name}-Ip-Config"
      frontend_port_name             = var.application_gateway_config.fe_port_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.application_gateway_config.routing_rule
    content {
      name                       = request_routing_rule.key
      rule_type                  = request_routing_rule.value[0]
      backend_address_pool_name  = request_routing_rule.value[1]
      backend_http_settings_name = request_routing_rule.value[2]
      http_listener_name         = request_routing_rule.value[3]
    }
  }
} # end of appgw resource block