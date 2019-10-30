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
#   PROD VNET                                                       
##########################################################################

variable "Prod-Network-RG" {
  default = {
    name     = "Prod-Network-RG"
    location = "southeastasia"
  }
}

variable "Prod-VNet" {
  default = {
    name          = "Prod-VNet"
    address_space = ["10.1.0.0/16"]
  }
}

variable "Prod-Subnets" {
  default = {
    "AzureBastionSubnet" = "10.1.0.0/27"
  }
}

variable "Prod-Hub-Peering" {
  default = {
    name                         = "Prod-Hub-Peering"
    allow_virtual_network_access = "false"
    allow_forwarded_traffic      = "false"
    allow_gateway_transit       = "false"
    use_remote_gateways          = "true"
  }
}

variable "Hub-Prod-Peering" {
  default = {
    name                         = "Hub-Prod-Peering"
    allow_virtual_network_access = "false"
    allow_forwarded_traffic      = "false"
    allow_gateway_transit       = "true"
    use_remote_gateways          = "false"
  }
}


##########################################################################
#   NETWORK SECURITY GROUP (NSG)                                                     
##########################################################################

variable "Prod-AzureBastion-NSG" {
  default = "Prod-AzureBastion-NSG"
}

variable "Prod-AzureBastion-NSG-Rules" {
  description = "[1000, In/out, allow/deny, TCP/UDP/*, (src_port), (dst_port), src_address_prefix, dst_address_prefix]"
  default = {
    ##"rule1" = [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
    "Bastion-In-Allow"         = [100, "Inbound", "Allow", "TCP", "*", "443", "*", "*"]
    "Bastion-Control-In-Allow" = [120, "Inbound", "Allow", "TCP", "*", "443", "GatewayManager", "*"]


    "Bastion-VNet-Out-Allow"  = [100, "Outbound", "Allow", "TCP", "*", "22-3389", "*", "VirtualNetwork"]
    "Bastion-Azure-Out-Allow" = [120, "Outbound", "Allow", "TCP", "*", "443", "*", "AzureCloud"]
    # "Bastion-Out-Deny" = [900, "Outbound", "Deny", "*", "*", "*","*","*"]
    # "Bastion-In-Deny" = [900, "Inbound", "Deny", "*", "*","*","*","*"]
  }
}
