# Creage a management groups
# New root management group
resource "azurerm_management_group" "parent" {
  display_name = local.parent_mng_group_name
}