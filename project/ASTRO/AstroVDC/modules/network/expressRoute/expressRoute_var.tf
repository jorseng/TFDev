variable "resource_group" {
  default = {
      name = ""
      location = ""
  }
}

variable "express_route" {
  default ={
      name = ""
      service_provider_name = ""
      peering_location = ""
      bandwidth_in_mbps = 50
      sku_tier = ""
      sku_family = ""
  }
}
