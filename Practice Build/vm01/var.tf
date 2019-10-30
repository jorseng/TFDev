variable "main_vnet_name" {
  default     = "main_vnet"
  description = "Virtual Network Name"
}

variable "main_vnet_cidr" {
  type        = "list"
  default     = ["192.168.0.0/16"]
  description = "Your Virtual Network Address Space"
}

variable "main_subnet_name" {
  default = "main_subnet1"
}

variable "main_subnet_cidr" {
  default = "192.168.1.0/24"
}

variable "vm_prefix" {
  default = "vmApp"
}

variable "vm_ip_prefix" {
  default = "192.168.1."
}
