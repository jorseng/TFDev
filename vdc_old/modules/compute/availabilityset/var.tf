variable "resource_group" {
    default = {
        name     = ""
        location = ""
    }
  
}

variable "availability_set_profile" {
  default = {
    name                         = "aset-name"
    platform_update_domain_count = 5
    platform_fault_domain_count  = 2
    managed                      = true
  }
}

variable "vmcount" {
  default = 3
}


variable "vm_profile" {
  default = {
    name = "vm-name"
    size        = "Standard_D2s_v3"
  }
}

variable "os_profile" {
  default = {
    hostname = "DefaultHostName"
    username        = "DemoAdmin"
    password        = "DemoPassAdminW0rd"
  }
}

variable "os_image" {
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "boot_diagnostics" {
  default = {
    status      = "false"
    storage_uri = ""
    #storage_uri = "${join(",", azurerm_storage_account.diagstore.*.primary_blob_endpoint)}"
  }
}

variable "subnet_id" {
  default = ""
}
