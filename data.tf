data "azurerm_subscription" "current" {}

output "subscription_data" {
  value = data.azurerm_subscription.current  
}