# resource "azurerm_virtual_machine_extension" "azdc01-startup-script" {
#   name                 = "install-adds-dns"
#   resource_group_name  = "${azurerm_resource_group.hubrg.name}"
#   location             = "${azurerm_resource_group.hubrg.location}"
#   virtual_machine_name = "${azurerm_virtual_machine.azdc01.name}"
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.9"
#   depends_on           = ["azurerm_virtual_machine.azdc01"]
#   settings = <<SETTINGS
#     { 
#         "commandToExecute":"powershell Set-ExecutionPolicy -ExecutionPolicy Unrestricted; $SafeModeAdminPassword = ConvertTo-SecureString('DemoPassAdminW0rd') -AsPlainText -Force; set-timezone -Id 'Singapore Standard Time'; Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -ComputerName azdc01; Install-ADDSForest -DomainName 'azdemo.com' -DomainNetbiosName 'azdemo' -SafeModeAdministratorPassword $SafeModeAdminPassword -ForestMode Win2012R2 -DomainMode Win2012R2 -InstallDns -LogPath 'C:\\Windows\\NTDS' -SysvolPath 'C:\\Windows\\SYSVOL' -DatabasePath 'C:\\Windows\\NTDS' -NoRebootOnCompletion: $false -Force: $true;"
#     }
#     SETTINGS
# }

# resource "azurerm_virtual_machine_extension" "azdc02-startup-script" {
#   name                 = "install-adds-dns"
#   resource_group_name  = "${azurerm_resource_group.hubrg.name}"
#   location             = "${azurerm_resource_group.hubrg.location}"
#   virtual_machine_name = "${azurerm_virtual_machine.azdc02.name}"
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.9"
#   settings = <<SETTINGS
#     { 
#       "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/dc2_provisioning.ps1"],
#       "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File dc2_provisioning.ps1"
#     } 
#     SETTINGS
# }
resource "azurerm_virtual_machine_extension" "jumpserver01-startup-script" {
  name                 = "join-domain"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.jumpserver01.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    { 
      "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/joindomain.ps1"],
      "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File joindomain.ps1"
    }
    SETTINGS
}
# App01-web01
resource "azurerm_virtual_machine_extension" "iis1" {
  name                 = "install-iis1"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.app01-web01.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/app01web01.ps1"],
      "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File app01web01.ps1"
    }
    SETTINGS
}

resource "azurerm_virtual_machine_extension" "iis2" {
  name                 = "install-iis2"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  location             = "${azurerm_resource_group.hubrg.location}"
  virtual_machine_name = "${azurerm_virtual_machine.app01-web02.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/jorseng/TFDev/master/hub/app01web02.ps1"],
      "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File app01web02.ps1"
    }
    SETTINGS
}

