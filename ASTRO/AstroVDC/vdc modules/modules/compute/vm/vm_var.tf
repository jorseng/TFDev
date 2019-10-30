variable "resource_group" {
  default = {
    name     = ""
    location = ""
  }
}

variable "virtual_machine" {
  default = {
    name                  = "" # azure vm name
    host_name             = "" # vm host name
    admin_username        = ""
    admin_password        = ""
    private_ip_allocation = "" # Static / Dynamic
    private_ip_address    = "" # Only use when Static is defined
    vm_size               = ""
    managed_disk_type     = "Standard_LRS"
  }
}

variable "new_data_disk" {
  default = {
    #"lun" = ["managed_disk_type", "disk_size_gb"]
    "0" = ["Standard_LRS", "128"]
  }
}

variable "attach_data_disk" {
  default = {
    # lun here should not overlap with lun in "new_data_disk"
    # "1" = ["ref_disk_name", "ref_disk_id", ref_disk_size_gb""]
  }
}

variable "image_reference_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "storage_uri" {
  default = ""
    #storage_uri = "${join(",", azurerm_storage_account.diagstore.*.primary_blob_endpoint)}"
}

variable "pip_id" {
  default     =  ""
}