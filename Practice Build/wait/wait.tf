provider "azurerm" {
  version = "1.27.1"
}

resource "null_resource" "restart-delay" {
  provisioner "local-exec" {
    command = "sleep 20"
  }
}

resource "azurerm_resource_group" "waitrg" {
  name       = "waitrg2"
  location   = "SoutheastAsia"
  depends_on = ["null_resource.restart-delay"]
}
