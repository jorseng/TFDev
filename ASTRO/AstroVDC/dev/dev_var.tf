##########################################################################
#   SUBSCRIPTIONS                                                       
##########################################################################

variable "Subscription" {
  default = {
    dev_id  = "15f39886-cf2a-4dde-b23d-24a2498809f6" #ASTRO DEV 
    prod_id = "13ef02a6-7352-4c93-834e-b739a3a65a0b" #ASTRO PROD
  }
}


##########################################################################
#   DEV VNET                                                       
##########################################################################

variable "Dev-Network-RG" {
  default = {
    name     = "Dev-Network-RG"
    location = "southeastasia"
  }
}

variable "Dev-VNet" {
  default = {
    name          = "Dev-VNet"
    address_space = ["10.2.0.0/16"]
  }
}

variable "Dev-Subnets" {
  default = {
    "AzureBastionSubnet" = "10.2.0.0/27"
  }
}

variable "Dev-Hub-Peering" {
  default = {
    name                         = "Dev-Hub-Peering"
    allow_virtual_network_access = "false"
    allow_forwarded_traffic      = "false"
    allow_gateway_transit       = "false"
    use_remote_gateways          = "true"
  }
}

variable "Hub-Dev-Peering" {
  default = {
    name                         = "Hub-Dev-Peering"
    allow_virtual_network_access = "false"
    allow_forwarded_traffic      = "false"
    allow_gateway_transit       = "true"
    use_remote_gateways          = "false"
  }
}



##########################################################################
#   NETWORK SECURITY GROUP (NSG)                                                     
##########################################################################

variable "Dev-AzureBastionHost-NSG" {
  default = "Dev-AzureBastionHost-NSG"
}

variable "Dev-AzureBastionHost-NSG-Rules" {
  description = "[priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]"
  default = {
    #"rule1" = [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
    "Inbound_traffic_gateway_manager" = [1000, "Inbound", "Allow", "*", "*", "*", "GatewayManager"]
    "Inbound_azure_clouod"            = [1100, "Inbound", "Allow", "*", "*", "*", "AzureCloud"]
    "Allow_https"                     = [1200, "Inbound", "Allow", "TCP", "443", "*", "*"]
  }
}