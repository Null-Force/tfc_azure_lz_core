locals {
  parent_mng_group_name = var.parent_mng_group_name

  mng_groups_parsed_l1 = jsondecode(var.mng_groups_names)

  mng_groups_parsed_l2 = merge([
    for group, names in local.mng_groups_parsed_l1 :
    {
      for name in names :
      "${group}_${name}" => {
        name  = name
        group = group
      }
    }
    if length(names) > 0
  ]...)
}