#Sql Server
resource "azurerm_sql_server" "app01-sqlserver" {
  name                         = "app01-sqlserver"
  resource_group_name          = "${azurerm_resource_group.hubrg.name}"
  location                     = "${azurerm_resource_group.hubrg.location}"
  version                      = "12.0"
  administrator_login          = "DemoAdmin"
  administrator_login_password = "DemoPassAdminW0rd"
}

# SQL Server Firewall Rule assginment
resource "azurerm_sql_firewall_rule" "app01-sqlserver-fw-rule" {
  name                = "AllowAzureServices"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  server_name         = "${azurerm_sql_server.app01-sqlserver.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Database provisioning
resource "azurerm_sql_database" "app01-db01" {
  name                = "app01-db01"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  location            = "${azurerm_resource_group.hubrg.location}"
  server_name         = "${azurerm_sql_server.app01-sqlserver.name}"
  edition             = "Standard"
}
