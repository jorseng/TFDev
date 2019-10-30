set-timezone -Id "Singapore Standard Time"
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -ComputerName azdc02

Install-ADDSDomainController -CreateDnsDelegation:$false `
-Credential($Cred) -DomainName 'azdemo.com' `
-SafeModeAdministratorPassword $SafeModeAdminPassword `
-InstallDns:$true `
-DatabasePath 'C:\Windows\NTDS' `
-LogPath 'C:\Windows\NTDS' `
-SysvolPath 'C:\Windows\SYSVOL' `
-NoGlobalCatalog:$false -SiteName 'Default-First-Site-Name' `
-NoRebootOnCompletion:$false `
-Force:$true

#Start-Sleep -s 900
$Username = "azdemo\DemoAdmin"
$Password = ConvertTo-SecureString("DemoPassAdminW0rd") -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential($Username,$Password)
$SafeModeAdminPassword = ConvertTo-SecureString("DemoPassAdminW0rd") -AsPlainText -Force