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
    allocation_method = "Static"   # for app gateway, must be Static
    sku               = "Standard" # for app gateway, must be Standard
  }
}

variable "application_gateway_config" {
  default = {
    name         = ""
    sku_type     = ""
    sku_tier     = ""
    sku_capacity = 2
    #fe_port_name = "" # use the same for the listener
    fe_port = [80] # Frontend Ports need to be created here first before being referred in http_settings / routing rule
    be_pool = {
      #"be_pool_name" = ["ip_address"]
      #"be_pool1" = ["10.2.0.0"]
    }
    be_http_settings = {
      # /path must be the same as the one in path rule.
      #"http_settings_name" = ["cookie_affinity", "protocol", "(port)", "(timeout)","/path/"]
      #"http_setting1" = ["Disabled", "Http", 80, 2, "/path/"]
    }

    routing_rule = {
      # http_settings and be_pool need to be defined first
      # be_settings and be_pool name must match in the routing rule as above
      #"rule1" = ["type", "be_pool_name", "be_http_settings_name", "listener_name", "listener_protocol","(port_no)", "url_path_map_name"]
      #"rule1" = ["Basic/PathBasedRouting", "listener1", "be_pool1", "http_setting1","Http", 80,"url_path_map_name"]
    }

    url_path_map = {
      #"url_path_map1" = ["default_be_pool","default_be_setting",{
      #  "path_rule1" = [["/path"],"default_be_pool","default_be_setting"]}]

    }

  }
}

# Backend pool can have "multiple pool" and each pool can have "multiple targets"
# "Multiple Routing rules" and each with settings and "multiple path based routing"

