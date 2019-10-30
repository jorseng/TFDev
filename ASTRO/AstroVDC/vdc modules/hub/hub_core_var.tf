variable "WS2016_CIS_L1_Image" {
  default = "/subscriptions/13ef02a6-7352-4c93-834e-b739a3a65a0b/resourceGroups/PROD-CIS-RG/providers/Microsoft.Compute/images/WS2016_251019"
}

variable "Hub-WAD-RG" {
  default = {
    name     = "Hub-WAD-RG"
    location = "southeastasia"
  }
}

variable "HUBWAD01" {
  default = {
    name                  = "HUBWAD01" # azure vm name
    host_name             = "HUBWAD01" # vm host name
    admin_username        = "admin.astro"
    admin_password        = "l90P6sqVmLMIuDbw"
    private_ip_allocation = "Static"    # Static / Dynamic
    private_ip_address    = "10.3.1.20" # Only use when Static is defined
    vm_size               = "Standard_D2s_v3"
    managed_disk_type     = "Premium_LRS" # Standard_LRS, StandardSSD_LRS, Premium_LRS or UltraSSD_LRS
  }
}

variable "HUBWAD01_Data_Disks" {
  default = {
    #"lun" = ["managed_disk_type", "disk_size_gb"]
    "0" = ["Premium_LRS", "128"]
  }
}

