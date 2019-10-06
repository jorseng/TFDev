variable "resource_group" {
  default = {
      name = "default-rg-name"
      location = "southeastasia"
  }
}

# variable "resource_group" {
#   default = {
#     count = 2
#     name = "default-rg-name"
#     location = "southeastasia"
#   }
# }
