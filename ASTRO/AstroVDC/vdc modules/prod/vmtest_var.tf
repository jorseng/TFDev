variable "vm_image" {
  default = "/subscriptions/13ef02a6-7352-4c93-834e-b739a3a65a0b/resourceGroups/PROD-CIS-RG/providers/Microsoft.Compute/images/WS2016_251019"
}

variable "resource_group" {
  default = {
    name     = "vmtest-rg"
    location = "southeastasia"
  }
}

variable "subnet" {
  default = {
    name           = "testvm-subnet"
    address_prefix = "10.1.2.0/28"
  }
}


variable "virtual_machine" {
  default = {
    name                  = "testimagevm" # azure vm name
    host_name             = "testimagevm" # vm host name
    admin_username        = "jorseng"
    admin_password        = "jspasswordtest1234!@#$"
    private_ip_allocation = "Dynamic" # Static / Dynamic
    private_ip_address    = ""        # Only use when Static is defined
    vm_size               = "Standard_D2s_V3"
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
    # lun here should not overlap with "new_data_disk"
    # "1" = ["ref_disk_name", "ref_disk_id", ref_disk_size_gb""]
  }
}

variable "storage_uri" {
  default = ""
  #storage_uri = "${join(",", azurerm_storage_account.diagstore.*.primary_blob_endpoint)}"
}



# NSG

variable "Test-NSG" {
  default = "Test-NSG"
}

variable "Test-NSG-Rules" {
  description = "[1000, In/out, allow/deny, TCP/UDP/*, (src_port), (dst_port), src_address_prefix, dst_address_prefix]"
  default = {
    ##"rule1" = [1000, "Inbound", "Allow", "TCP", "*", "*", "*", "*"]
    # "Bastion-Out-Deny" = [900, "Outbound", "Deny", "*", "*", "*","*","*"]
    # "Bastion-In-Deny" = [900, "Inbound", "Deny", "*", "*","*","*","*"]
  }
}
