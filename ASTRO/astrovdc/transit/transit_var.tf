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
  default = {
    "GatewaySubnet"       = "10.1.3.224/27"
    "AzureFirewallSubnet" = "10.1.0.0/26"
    "Prod-ExtWAF-Net01"   = "10.1.0.64/26"
    "Prod-IntWAF-Net01"   = "10.1.0.128/26"
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
#   GATEWAY                                                     
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


##########################################################################
#   NETWORK SECURITY GROUP                                                     
##########################################################################

variable "Prod-ExtWAF-NSG" {
  default     = "Prod-ExtWAF-NSG"
}

# WARNING: ADD/REMOVE RULES WILL DEASSOCIATE NSG FROM ASSIGNED SUBNET
# NOTE   : Taint the nsg association resource to recreate the association
# OR
# NOTE   : Run twice to reassociate the nsg association
variable "Prod-ExtWAF-NSG-Rules" {
  description = "[priority,direction,access,protocol,source_port_range,destination_port_range,source_address_prefix,destination_address_prefix]"
  default     = {
    "rule1" = [1000,"Inbound","Allow","TCP","*","*","*","*"]
    "rule2" = [1001,"Outbound","Allow","TCP","*","*","*","*"]
    "rule3" = [1002,"Outbound","Allow","TCP","*","*","*","*"]
  }
}

##########################################################################
#   UDR                                                     
##########################################################################

variable "route_table_name" {
  default     = "udr-test-table"
}

variable "routes" {
  default     = {
      "route1" = ["10.5.2.0/24","VnetLocal"]
  }
}