#Start-Sleep -s 900

$Username = "azdemo\DemoAdmin"
$Password = ConvertTo-SecureString("DemoPassAdminW0rd") -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential($Username,$Password)
Add-Computer -DomainName azdemo.com -Credential ($Cred) -Restart -Force