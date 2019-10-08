variable "resource_group" {
  default = {
    name     = ""
    location = ""
  }
}

variable "appgw_subnet_id" {
  default = ""
}

variable "appgw_pip" {
  default = {
    name              = ""
    allocation_method = "" #Dynamic Static
  }
}

variable "application_gateway_config" {
  default = {
    name         = ""
    sku_type     = "" # Standard_Small
    sku_tier     = ""
    sku_capacity = 2
    fe_port_name = "" # use the same for the listener
    fe_port      = 80
    be_pool = {
      #"be_pool_name" = ["ip_address"]
      #"be_pool1" = ["10.2.0.0"]
    }
    be_http_settings = {
      #"http_settings1" = ["cookie_affinity", "protocol", "(port)", "(timeout)",["path"]]
      #"http_setting1" = ["Disabled", "Http", 80, 2, ""]
    }
    routing_rule = {
      # be_pool_name must be defined in be_pool
      # be_settings name must be defined in the be_http_settings
      #"rule1" = ["type", "be_pool_name", "be_http_settings_name", "listener_name", "listener_protocol"]
      #"rule1" = ["Basic", "listener1", "be_pool1", "http_setting1","Http"]
    }
  }
}

# Backend pool can have "multiple pool" and each pool can have "multiple targets"
# "Multiple Routing rules" and each with settings and "multiple path based routing"

