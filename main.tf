# Creage a management groups

## New root management group
resource "azurerm_management_group" "parent" {
  display_name = local.parent_mng_group_name
}

## Create the first level management groups
resource "azurerm_management_group" "first_level" {
  for_each = local.first_level_mng_group_map

  display_name               = each.value.name
  parent_management_group_id = azurerm_management_group.parent.id
}

## Create the second level management groups
resource "azurerm_management_group" "second_level" {
  for_each = local.second_level_mng_group_map

  display_name               = each.value.name
  parent_management_group_id = azurerm_management_group.first_level[each.value.parent].id
}

# Create AD groups


resource "azuread_group" "owners" {
  for_each = merge(
    azurerm_management_group.first_level,
    azurerm_management_group.second_level
  )

  display_name            = "${each.value.display_name} - owners"
  owners                  = [data.azuread_client_config.current.object_id]
  security_enabled        = true
  assignable_to_role      = true
  description             = "Owners group for ${each.value.display_name} management group"
  prevent_duplicate_names = false
}