variable "resource_group" {
  default     = {
      name = ""
      location = ""
  }
}

variable "storage_account" {
  default     = {
      name = ""
      account_tier = "" #Standard
      account_replication_type = "" #LRS
  }
}