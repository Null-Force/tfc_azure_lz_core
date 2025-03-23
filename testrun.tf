data "azurerm_client_config" "current" {}

output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "israelcentral"
}