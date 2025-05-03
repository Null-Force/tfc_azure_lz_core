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

# Create Entra ID securety groups for each management group with owners, contributer and reader roles

## Create groups for each management group
resource "azuread_group" "default" {
  for_each = local.roles_and_groups

  display_name            = each.value.display_name
  owners                  = each.value.owners
  security_enabled        = each.value.security_enabled
  description             = each.value.description
  prevent_duplicate_names = each.value.prevent_duplicate_names
}

## Assign roles to the groups
resource "azurerm_role_assignment" "default" {
  for_each = local.roles_and_groups

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azuread_group.default[each.key].object_id
}