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
}