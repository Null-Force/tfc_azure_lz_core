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


# Create roles and assign them to the management groups
# Each management group will have owner, contributer and read role

resource "azurerm_role_definition" "owner" {
  for_each = merge(
    azurerm_management_group.first_level,
    azurerm_management_group.second_level
  )
  name        = "${each.value.name} - owner"
  scope       = each.value.id
  description = "Custom owner role scoped to a management group."
  permissions {
    actions     = ["*"]
    not_actions = []
  }
  assignable_scopes = [each.value.id]
}

# resource "azurerm_role_assignment" "owner" {
#   for_each = merge(
#     azurerm_management_group.first_level,
#     azurerm_management_group.second_level
#   )

#   scope                = each.value.id
#   role_definition_name = "Owner"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# resource "azurerm_role_assignment" "contributer" {
#   for_each = local.first_level_mng_group_map

#   scope                = azurerm_management_group.first_level[each.key].id
#   role_definition_name = "Contributor"
#   principal_id         = data.azurerm_client_config.current.object_id
# }
# resource "azurerm_role_assignment" "reader" {
#   for_each = local.first_level_mng_group_map

#   scope                = azurerm_management_group.first_level[each.key].id
#   role_definition_name = "Reader"
#   principal_id         = data.azurerm_client_config.current.object_id
# }