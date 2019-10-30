variable "nsgRuleSet" {
  description = "[priority,direction,access,protocol,source_port_range,destination_port_range,source_address_prefix,destination_address_prefix]"
  default     = {
      "rule1" = [1000,"Inbound","Allow","TCP","*","*","*","*"]
      "rule2" = [1001,"Outbound","Allow","TCP","*","*","*","*"]
  }
}

# variable "nsgSet" {
#   default     = {
#     name                        = ["rule1"  ,"rule2"    ]
#     priority                    = [1000     ,1001       ]
#     direction                   = ["Inbound","Outbound" ]
#     access                      = ["Allow"  ,"Allow"    ]
#     protocol                    = ["TCP"    ,"TCP"      ]
#     source_port_range           = ["*"      ,"*"        ]
#     destination_port_range      = ["*"      ,"*"        ]
#     source_address_prefix       = ["*"      ,"*"        ]
#     destination_address_prefix  = ["*"      ,"*"        ]
#   }
# }