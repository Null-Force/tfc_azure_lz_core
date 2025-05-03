locals {
  parent_mng_group_name = var.parent_mng_group_name


  # The names of the management groups
  management_groups_tree = jsondecode(file("${path.module}/config/management_groups_tree.json"))

  # First level management group
  first_level_mng_group_map = {
    for key, value in local.management_groups_tree :
    key => {
      name = value.name
    }
  }

  # Second level management group
  second_level_mng_group_map = merge([
    for root_key, root_value in local.management_groups_tree : {
      for key, value in root_value.children :
      key => {
        name   = value.name
        parent = root_key
      }
    }
  ]...)

  # Merge management groups
  created_management_groups = merge(
    azurerm_management_group.first_level,
    azurerm_management_group.second_level
  )

  # Create map of groups with their display names and roles
  # The groups are created for each management group with owners, contributer and reader roles
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
        scope                   = local.created_management_groups[group_key].id
      }
    }
  ]...)
}