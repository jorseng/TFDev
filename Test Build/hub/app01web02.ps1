set-timezone -Id "Singapore Standard Time"

Add-WindowsFeature Web-Asp-Net45;
Add-WindowsFeature NET-Framework-45-Core;
Add-WindowsFeature Web-Net-Ext45;
Add-WindowsFeature Web-ISAPI-Ext;
Add-WindowsFeature Web-ISAPI-Filter;
Add-WindowsFeature Web-Mgmt-Console;
Add-WindowsFeature Web-Scripting-Tools;
Add-WindowsFeature Search-Service;
Add-WindowsFeature Web-Filtering;
Add-WindowsFeature Web-Basic-Auth;
Add-WindowsFeature Web-Windows-Auth;
Add-WindowsFeature Web-Default-Doc;
Add-WindowsFeature Web-Http-Errors;
Add-WindowsFeature Web-Static-Content;

mkdir C:\\source; 
wget https://webformapp.blob.core.windows.net/webformappcontainer/WebFormApp.zip -outfile C:\\source\\WebFormApp.zip; 
Expand-Archive C:\\source\\WebFormApp.zip -DestinationPath C:\\source;
Move-Item C:\source\WebFormApp C:\inetpub\wwwroot;

function Update-DB {

    $connectionString = "Data Source=app01-sqlserver.database.windows.net;Initial Catalog=app01-db01;User ID=DemoAdmin;Password=DemoPassAdminW0rd;"
    
    $sqlCommand = "insert into AppUsers (username, userpw) values ('testuser02','testpassword');"

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()
    Write-Host 'Connection Established'
    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataset) | Out-Null

    $connection.Close()
    Write-Host 'Disconnected'
    $dataset.Tables
}

Update-DB;
New-WebApplication -Name WebFormApp -Site 'Default Web Site' -PhysicalPath C:\inetpub\wwwroot\WebFormApp -ApplicationPool DefaultAppPool;
$Username = "azdemo\DemoAdmin"
$Password = ConvertTo-SecureString("DemoPassAdminW0rd") -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential($Username,$Password)
Add-Computer -DomainName azdemo.com -Credential ($Cred) -Restart -Force