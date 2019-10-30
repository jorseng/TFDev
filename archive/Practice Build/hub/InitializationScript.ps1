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

Move-Item C:\source\WebFormApp C:\inetpub\wwwroot;

function Initialize-DB {

    $connectionString = "Data Source=app01-sqlserver.database.windows.net;Initial Catalog=app01-db01;User ID=DemoAdmin;Password=DemoPassAdminW0rd;"
    
    $sqlCommand = "Create table AppUsers (
	id int not null identity(1,1) primary key,
	username varchar(50),
	userpw varchar(50));
    insert into AppUsers (username, userpw) values ('testuser','testpassword');"

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

Initialize-DB;
New-WebApplication -Name WebFormApp -Site 'Default Web Site' -PhysicalPath C:\inetpub\wwwroot\WebFormApp -ApplicationPool DefaultAppPool;