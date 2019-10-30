variable "resource_group" {
  default     = {
      name = ""
      location = ""
  }
}

variable "log_analytics" {
  default     = {
      name = ""
      sku = ""
  }
}