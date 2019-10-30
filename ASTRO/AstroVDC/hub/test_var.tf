# variable "rg_map" {
#   default     = {
#       "rg1" = "southeastasia"
#       "rg2" = "southeastasia"
#   }
# }

##########################################################################
#   PRODUCTION HUB                                                     
##########################################################################
# RG, VNET, SUBNETS 

# variable "Hub2-Network-RG" {
#   default = {
#     name     = "Test-RG"
#     location = "southeastasia"
#   }
# }

# variable "Hub2-VNet" {
#   default = {
#     name          = "Test-VNet"
#     address_space = ["10.10.0.0/16"]
#   }
# }

# variable "Hub2-Subnets" {
#   description = ""
#   default = {
#     "Net01"       = "10.10.0.192/27"
#     "Net02"       = "10.10.0.0/26"
#   }
# }




# variable "Hub2-ExtWAF-NSG" {
#   default = "Hub-ExtWAF-NSG"
# }

# variable "Hub2-ExtWAF-NSG-Rules" {
#   description = "[priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]"
#   default = {
#     #"rule1" = [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
#     #"Allow_Inbound_Ext_DMZ" = [1000, "Inbound", "Allow", "TCP", " 65200-65535", "*", "*", "*"]
#   }
# }
