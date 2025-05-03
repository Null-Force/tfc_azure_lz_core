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

locals {
  created_management_groups = merge(
    azurerm_management_group.first_level,
    azurerm_management_group.second_level
  )

  role_types = ["Owner", "Contributor", "Reader"]
  roles_and_groups = merge([
    for group_key, group_value in local.created_management_groups : {
      for role in local.role_types :
      "${role}_${group_key}" => {
        role_definition_name    = role
        display_name            = "management group - ${group_value.display_name} - ${role}"
        description             = "${role}'s group for ${group_value.display_name} management group"        
        owners                  = [data.azuread_client_config.current.object_id]
        security_enabled        = true
        prevent_duplicate_names = false
        scope = local.created_management_groups[group_key].id
      }
    }
  ]...)
}

output "roles_and_groups" {
  value = local.roles_and_groups
}

resource "azuread_group" "default" {
  for_each = local.roles_and_groups

  display_name            = each.value.display_name
  owners                  = each.value.owners
  security_enabled        = each.value.security_enabled
  description             = each.value.description
  prevent_duplicate_names = each.value.prevent_duplicate_names  
}

# resource "azurerm_role_assignment" "default" {
#   for_each = local.roles_and_groups

#   scope                = 
#   role_definition_name = each.value.role_definition_name
#   principal_id         = azuread_group.default[each.key].object_id
# }





# ## Create the owners group for each management group
# resource "azuread_group" "owners" {
#   for_each = local.created_management_groups

#   display_name            = "management group - ${each.value.display_name} - owners"
#   owners                  = [data.azuread_client_config.current.object_id]
#   security_enabled        = true
#   description             = "Owners group for ${each.value.display_name} management group"
#   prevent_duplicate_names = false
# }

# resource "azurerm_role_assignment" "owners" {
#   for_each = local.created_management_groups

#   scope                = each.value.id
#   role_definition_name = "Owner"
#   principal_id         = azuread_group.owners[each.key].object_id
# }

# ## Create the contributors group for each management group
# resource "azuread_group" "contributors" {
#   for_each = local.created_management_groups

#   display_name            = "management group - ${each.value.display_name} - contributors"
#   owners                  = [data.azuread_client_config.current.object_id]
#   security_enabled        = true
#   description             = "Contributors group for ${each.value.display_name} management group"
#   prevent_duplicate_names = false
# }
# resource "azurerm_role_assignment" "contributors" {
#   for_each = local.created_management_groups

#   scope                = each.value.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_group.contributors[each.key].object_id
# }

# ## Create the readers group for each management group
# resource "azuread_group" "readers" {
#   for_each = local.created_management_groups

#   display_name            = "management group - ${each.value.display_name} - readers"
#   owners                  = [data.azuread_client_config.current.object_id]
#   security_enabled        = true
#   description             = "Readers group for ${each.value.display_name} management group"
#   prevent_duplicate_names = false
# }
# resource "azurerm_role_assignment" "readers" {
#   for_each = local.created_management_groups

#   scope                = each.value.id
#   role_definition_name = "Reader"
#   principal_id         = azuread_group.readers[each.key].object_id
# }