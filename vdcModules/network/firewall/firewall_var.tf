variable "resource_group" {
  default = {
    name     = ""
    location = ""
  }
}

variable "subnet_id" {
  default = ""
}

variable "fw_pip" {
  default = {
    name              = ""
    allocation_method = ""
    sku               = ""
  }
}

variable "firewall_name" {
  default = ""
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
