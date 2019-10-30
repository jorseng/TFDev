THIS IS AN EXAMPLE OF FILE WITH HIDDEN CHARACTERS.

#$Username = "azdemo\DemoAdmin"
#$Password = ConvertTo-SecureString("DemoPassAdminW0rd") -AsPlainText -Force
#$Cred = New-Object System.Management.Automation.PSCredential($Username,$Password)
#add-computer -domainname azdemo.com –credential ($Cred) -restart –force;
