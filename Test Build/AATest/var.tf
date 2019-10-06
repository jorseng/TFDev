provider "azurerm" {
  version = "1.28.0"
}

variable "rg" {
  default = "AATest-RG"
}

variable "location" {
  default = "southeastasia"
}

variable "sa" {
  default = "aatestdsc"
}

variable "vnet" {
  default = "AAtest-vnet"
}

variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "subnet" {
  default = "sharedsubnet"
}

variable "subnet_address_prefix" {
  default = "10.0.1.0/24"
}

variable "pip" {
  default = "vmAA-pip"
}

variable "private_ip" {
  default = "10.0.1.5"
}


variable "nic" {
  default = "vmAA-nic"
}

variable "ip_config" {
  default = "vmAA-ipconfig"
}

variable "vmAA" {
  default = "vmAA"
}


variable "azauto" {
  default = "AATestAccount"
}

