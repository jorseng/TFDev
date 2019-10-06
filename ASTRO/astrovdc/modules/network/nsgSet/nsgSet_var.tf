variable "resource_group" {
  default     = {
      name = ""
      location = ""
  }
}

variable "nsg_name" {
  default = ""
}

variable "nsg_rule_set" {
  description = "[priority,direction,access,protocol,source_port_range,destination_port_range,source_address_prefix,destination_address_prefix]"
  default     = {
    #"rule1" = [1000,"Inbound","Allow","TCP","*","*","*","*"]
    "" = [1000,"Inbound","Allow","TCP","*","*","*","*"]
  }
}

variable "subnet_id" {
  default     = ""
}