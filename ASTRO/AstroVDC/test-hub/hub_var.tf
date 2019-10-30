##########################################################################
#   SUBSCRIPTIONS                                                       
##########################################################################

variable "Subscription" {
  default = {
    id = "5b98ba7c-c3f7-43ec-ac20-195d8109fe2b" # jorseng@jspowerapp.onmicrosoft.com
    #id = "13ef02a6-7352-4c93-834e-b739a3a65a0b"  # jorseng.tan@enfrasys.com
  }
}

##########################################################################
#   PRODUCTION HUB                                                     
##########################################################################
# RG, VNET, SUBNETS 

variable "Hub-Network-RG" {
  default = {
    name     = "Hub-Network-RG"
    location = "southeastasia"
  }
}

variable "Hub-VNet" {
  default = {
    name          = "Hub-VNet"
    address_space = ["10.3.0.0/22"]
  }
}

variable "Hub-Subnets" {
  description = "The sequence of the "
  default = {
    "GatewaySubnet"       = "10.3.0.192/27"
    "AzureFirewallSubnet" = "10.3.0.0/26"
    "Hub-ExtWAF-Net01"    = "10.3.0.64/26"
    "Hub-IntWAF-Net01"    = "10.3.0.128/26"
    "Hub-Net01"           = "10.3.1.0/28"
    "AzureBastionSubnet"  = "10.3.0.224/27"
    # Changes to the naming need to be set in the main.tf file
  }
}


##########################################################################
#   S2S VPN TUNNEL                                                   
##########################################################################

variable "Hub-VPN-GW01" {
  description = "Hub S2S VPN Virtual Gateway"
  default = {
    name                         = "Hub-VPN-GW01"
    type                         = "VPN"
    vpn_type                     = "RouteBased"
    sku                          = "VpnGW1"
    private_ip_allocation_method = "Dynamic"
    active_active                = "false"
    enable_bgp                   = "false"
  }
}

variable "Hub-VPN-GW01-PIP01" {
  description = "Hub Gateway Public IP"
  default = {
    name              = "Hub-VPN-GW01-PIP01"
    allocation_method = "Dynamic"
    sku               = "Basic"
  }
}

variable "Hub-Local-VPN-GW01" {
  description = "Local Gateway to connect with Hub VPN GW"
  default = {
    name            = "Hub-Local-VPN-GW01"
    gateway_address = "121.123.236.197"
    address_space   = "172.0.0.0/8"
  }
}

variable "S2SConnection" {
  description = "S2S Connection between local gateway and Hub gw"
  default = {
    name       = "Hub-Local-S2S-Connection01"
    type       = "IPsec"
    shared_key = "u#d(W5;nl:z^"
  }
}

##########################################################################
#   EXPRESS ROUTE                                                     
##########################################################################

variable "expressRoute" {
  default = {
    name                  = "hub-ERCircuit-01"
    service_provider_name = "Time dotCom"
    peering_location      = "Kuala Lumpur"
    bandwidth_in_mbps     = 50
    sku_tier              = "Standard"
    sku_family            = "MeteredData"
  }
}

# PIP For ER GW
variable "Hub-ER-GW01-PIP01" {
  # public ip for gw needs to be dynamic and basic
  default = {
    name              = "Hub-ER-GW01-PIP01"
    allocation_method = "Dynamic"
    sku               = "Basic"
  }
}

# Gateway
variable "Hub-ER-GW01" {
  default = {
    name                         = "Hub-ER-GW01"
    type                         = "ExpressRoute"
    vpn_type                     = "RouteBased"
    sku                          = "Standard" # missing in terraform
    private_ip_allocation_method = "Dynamic"
    #vpn_client_configuration = "" # for point to site
  }
}


##########################################################################
#   FIREWALL                                                     
##########################################################################

variable "firewall_name" {
  default = "Hub-Az-FW01"
}

variable "fw_pip" {
  default = {
    name              = "Hub-Az-FW01-PIP01"
    allocation_method = "Static"
    sku               = "Standard"
  }
}


variable "nat_rule_collection" {
  default = {
    # "nat-rule-collection-1" = [1000, "Dnat",
    #   {"rule1" = [["10.0.0.0/16"], ["53"], ["8.8.8.8", "8.8.4.4"], ["TCP", "UDP"], "10.0.0.1", "80"]
    #    "rule2" = [["10.0.1.0/16"], ["53"], ["8.8.8.8", "8.8.4.4"], ["TCP", "UDP"], "10.0.0.1", "80"]
    #   }]

  }
}

variable "network_rule_collection" {
  default = {
    # "network-rule-collection-1" = [1000, "Allow",
    #   {"rule1" = [["10.0.0.0/16"], ["53"], ["8.8.8.8", "8.8.4.4"], ["TCP", "UDP"]]
    #    "rule2" = [["10.0.1.0/16"], ["53"], ["8.8.8.8", "8.8.4.4"], ["TCP", "UDP"]]
    #   }]
  }
}

variable "app_rule_collection" {
  default = {
    # "app-rule-collection-1" = [1000, "Allow",
    #   {"rule1" = [["10.0.0.0/16"], ["53"], ["*.google.com"]]
    #    "rule2" = [["10.0.0.0/16"], ["53"], ["*.google.com"]]
    #   }]
  }
}

##########################################################################
#   NETWORK SECURITY GROUP                                                     
##########################################################################

variable "Hub-ExtWAF-NSG" {
  default = "Hub-ExtWAF-NSG"
}

variable "Hub-ExtWAF-NSG-Rules" {
  description = "[priority,direction,access,protocol,source_port_range,destination_port_range,source_address_prefix,destination_address_prefix]"
  default = {
    #"rule1" = [1000, "Inbound/Outbound", "Allow/Deny", "TCP/UDP/ICMP/Any", "*", "*", "*", "*"]
    "InboundAllow"= [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
  }
}

variable "Hub-IntWAF-NSG" {
  default = "Hub-IntWAF-NSG"
}

variable "Hub-IntWAF-NSG-Rules" {
  description = "[priority,direction,access,protocol,source_port_range,destination_port_range,source_address_prefix,destination_address_prefix]"
  default = {
    #"rule1" = [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
    #"rule2" = [1001, "Outbound", "Allow", "TCP", "*", "*", "*", "*"]
    #"rule3" = [1002, "Outbound", "Allow", "TCP", "*", "*", "*", "*"]
  }
}

variable "Hub-Net01-NSG" {
  default = "Hub-Net01-NSG"
}

variable "Hub-Net01-NSG-Rules" {
  default = {
    #"rule1" = [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
    #"rule2" = [1001, "Outbound", "Allow", "TCP", "*", "*", "*", "*"]
    #"rule3" = [1002, "Outbound", "Allow", "TCP", "*", "*", "*", "*"]
  }
}

##########################################################################
#   UDR                                                     
##########################################################################

variable "route_table_name" {
  default = "udr-test-table"
}

variable "routes" {
  default = {
    "route1" = ["10.5.2.0/24", "VnetLocal"]
  }
}


##########################################################################
#   APPLICATION GATEWAY - External                                                     
##########################################################################

variable "Hub-Ext-DMZ-APPGW01-PIP01" {
  default = {
    name              = "Hub-Ext-DMZ-APPGW01-PIP01"
    allocation_method = "Static"   # for app gateway, must be Static
    sku               = "Standard" # for app gateway, must be Standard
  }
}


variable "Hub-Ext-DMZ-APPGW01" {
  default = {
    name         = "Hub-Ext-DMZ-APPGW01"
    sku_type     = "WAF_v2" # Standard_Small, Standard_medium, Standard_Large, Standard_v2, WAF_Large, WAF_Medium, WAF_v2
    sku_tier     = "WAF_v2" # Standard, Standard_v2, WAF, WAF_v2
    sku_capacity = 2
    fe_port      = [80] # Define the ports before configuring below.
    be_pool = {
      #"be_pool_name" = ["ip_address"]
      "default_pool" = ["10.0.0.1"]
    }
    be_http_settings = {
      #"http_settings_name" = ["cookie_affinity", "protocol", "(port)", "(timeout)",["/path/"]]
      "default_be_http_setting" = ["Disabled", "Http", 80, 20, "/path"]
    }

    routing_rules = {
      # be_pool_name must be defined in be_pool
      # be_settings name must be defined in the be_http_settings
      #"rule Name" = ["type=Basic/PathBasedRouting", "be_pool_name", "be_http_settings_name", "listener_name", "listener_protocol","url_path_map_name (optional)"]
      "default_rule" = ["PathBasedRouting", "default_pool", "default_be_http_setting", "default_listener", "Http", 80,"url_path_map1"]
    }

    url_path_map = {
      # Take note that path_rule_name is a nested map in url_path_map
      # "url_path_map_name" = ["default_pool_name","default_be_http_setting_name",{
      #   "path_rule_name" = [["/path"],"alternate_pool_name","alternate_http_setting_name"]}]

      "url_path_map1" = ["default_pool","default_be_http_setting",{
        "path_rule1" = [["/path"],"default_pool","default_be_http_setting"]}]
    }
  }
}
