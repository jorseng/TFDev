##########################################################################
#   SUBSCRIPTIONS                                                       
##########################################################################

variable "Subscription" {
  default = {
    id = "5b98ba7c-c3f7-43ec-ac20-195d8109fe2b"
  }
}

##########################################################################
#   TRANSIT HUB                                                     
##########################################################################
# RG, VNET, SUBNETS 

variable "Transit-Network-RG" {
  default = {
    name     = "Transit-Network-RG"
    location = "southeastasia"
  }
}

variable "Transit-VNet" {
  default = {
    name          = "Transit-VNet"
    address_space = ["10.1.0.0/22"]
  }
}

variable "Transit-Subnets" {
  description = "The sequence of the "
  default = {
    "GatewaySubnet"       = "10.1.3.224/27" # Gateway Subnet here
    "AzureFirewallSubnet" = "10.1.0.0/26"   # Azure Firewall Subnet here
    "Prod-ExtWAF-Net01"   = "10.1.0.64/26"  # AppGW-Ext Subnet here
    "Prod-IntWAF-Net01"   = "10.1.0.128/26" # AppGW-Int Subnet here
  }
}


##########################################################################
#   GATEWAY                                                     
##########################################################################

variable "Transit-VPN-GW01" {
  description = "Transit Virtual Gateway"
  default = {
    name     = "Transit-VPN-GW01"
    type     = "VPN"
    vpn_type = "RouteBased"
    sku      = "Standard"
  }
}

variable "Transit-GW01-PIP01" {
  description = "Transit Gateway Public IP"
  default = {
    name              = "Transit-GW01-PIP01"
    allocation_method = "Static"
  }
}

variable "Transit-Local-GW01" {
  description = "Local Gateway to connect with transit VPN GW"
  default = {
    name            = "Transit-Local-GW01"
    gateway_address = "202.186.91.230"
    address_space   = "192.168.0.0/21"
  }
}

variable "S2SConnection" {
  description = "S2S Connection between local gateway and transit gw"
  default = {
    name       = "Transit-S2S-Connection01"
    type       = "IPsec"
    shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  }
}

##########################################################################
#   EXPRESS ROUTE                                                     
##########################################################################

variable "expressRoute" {
  default = {
    name                  = "Dev-ER-GW01"
    service_provider_name = "Time dotCom"
    peering_location      = "Kuala Lumpur"
    bandwidth_in_mbps     = 50
    sku_tier              = "Standard"
    sku_family            = "MeteredData"
  }
}

##########################################################################
#   FIREWALL                                                     
##########################################################################

variable "firewall_name" {
  default = "Transit-FW01"
}

variable "fw_pip" {
  default = {
    name              = "Transit-FW01-PIP01"
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

variable "Prod-ExtWAF-NSG" {
  default = "Prod-ExtWAF-NSG"
}

# WARNING: ADD/REMOVE RULES WILL DEASSOCIATE NSG FROM ASSIGNED SUBNET
# NOTE   : Taint the nsg association resource to recreate the association
# OR
# NOTE   : Run twice to reassociate the nsg association
variable "Prod-ExtWAF-NSG-Rules" {
  description = "[priority,direction,access,protocol,source_port_range,destination_port_range,source_address_prefix,destination_address_prefix]"
  default = {
    "rule1" = [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
    "rule2" = [1001, "Outbound", "Allow", "TCP", "*", "*", "*", "*"]
    "rule3" = [1002, "Outbound", "Allow", "TCP", "*", "*", "*", "*"]
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
#   APPLICATION GATEWAY                                                     
##########################################################################

variable "appgw_pip" {
  default = {
    name              = "test-appgw-pip"
    allocation_method = "Dynamic"
  }
}

variable "application_gateway_config" {
  default = {
    name         = "appgw-test"
    sku_type     = "Standard_Small"
    sku_tier     = "Standard"
    sku_capacity = 2
    fe_port_name = "feport-name-01" # use the same for the listener
    fe_port      = 80
    be_pool = {
      #"be_pool_name" = ["ip_address"]
      "be_pool1" = ["10.2.0.0"]
    }
    be_http_settings = {
      #"http_settings1" = ["cookie_affinity", "protocol", "(port)", "(timeout)",["path"]]
      "http_setting1" = ["Disabled", "Http", 80, 2, ""]
    }
    routing_rule = {
      # be_pool_name must be defined in be_pool
      # be_settings name must be defined in the be_http_settings
      #"rule1" = ["type", "be_pool_name", "be_http_settings_name", "listener_name", "listener_protocol"]
      "rule1" = ["Basic", "listener1", "be_pool1", "http_setting1","Http"]
    }
  }
}
