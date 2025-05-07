# All management groups
output "management_group_all" { value = merge(azurerm_management_group.parent, azurerm_management_group.first_level, azurerm_management_group.second_level) }

# Seperate outputs for each management group
## Root management group
output "management_group_root" { value = azurerm_management_group.parent }

## Platform management group
output "management_group_platform" { value = azurerm_management_group.first_level["platform"] }
output "management_group_management" { value = azurerm_management_group.second_level["management"] }
output "management_group_identity" { value = azurerm_management_group.second_level["identity"] }
output "management_group_connectivity" { value = azurerm_management_group.second_level["connectivity"] }

## Landing zones management group
output "management_group_landing_zones" { value = azurerm_management_group.first_level["landing_zones"] }
output "management_group_corporate" { value = azurerm_management_group.second_level["corporate"] }
output "management_group_development" { value = azurerm_management_group.second_level["development"] }
output "management_group_quality_assurance" { value = azurerm_management_group.second_level["quality_assurance"] }
output "management_group_demo" { value = azurerm_management_group.second_level["demo"] }
output "management_group_production" { value = azurerm_management_group.second_level["production"] }
output "management_group_training" { value = azurerm_management_group.second_level["training"] }
output "management_group_shared_services" { value = azurerm_management_group.second_level["shared_services"] }

## Decommissioned management group
output "management_group_decommissioned" { value = azurerm_management_group.first_level["decommissioned"] }

## Sandbox management group
output "management_group_sandbox" { value = azurerm_management_group.first_level["sandbox"] }





