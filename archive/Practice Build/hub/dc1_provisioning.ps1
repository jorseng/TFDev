$SafeModeAdminPassword = ConvertTo-SecureString("DemoPassAdminW0rd") -AsPlainText -Force
set-timezone -Id "Singapore Standard Time"
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -ComputerName azdc01

Install-ADDSForest -DomainName "azdemo.com" `
-DomainNetbiosName "azdemo" `
-SafeModeAdministratorPassword $SafeModeAdminPassword `
-ForestMode Win2012R2 `
-DomainMode Win2012R2 `
-InstallDns `
-LogPath 'C:\Windows\NTDS'`
-SysvolPath 'C:\Windows\SYSVOL' `
-DatabasePath 'C:\Windows\NTDS' `
-NoRebootOnCompletion: $false `
-Force: $true

# # create the forward lookup zone for DNS
# Add-DnsServerPrimaryZone -ReplicationScope Forest -Name "azdemo.com" -DynamicUpdate Secure
# # create a reverse lookup zone for DNS
# Add-DnsServerPrimaryZone -ReplicationScope Forest -NetworkId "192.168.0.0/16" -DynamicUpdate Secure