data "azurerm_subscription" "current" {}



variable "parent_mng_group_name" {
  description = "The names of the parent management groups"
  type        = string
  default     = "null_power"
}

variable "mng_groups_names" {
  description = "The names of the management groups"
  type        = string
  default     = "{\"platform\":[\"management\",\"identity\",\"connectivity\"],\"landing_zones\":[\"corporate\",\"online\"],\"decommissioned\":[],\"sandbox\":[]}"
}


locals {
  parent_mng_group_name = var.parent_mng_group_name

  mng_groups_parsed_l1 = jsondecode(var.mng_groups_names)

  mng_groups_parsed_l2 = {
    for group, names in local.mng_groups_parsed_l1 :
    group => [
      for name in names : {
        name  = name
        group = group
      }
    ]
    if length(names) > 0
  }
}

output "names_l2" {
  value = local.mng_groups_parsed_l2  
}


resource "azurerm_management_group" "parent" {  
  display_name = local.parent_mng_group_name
}

resource "azurerm_management_group" "mng_groups_l1" {
  for_each = local.mng_groups_parsed_l1

  display_name = each.key
  parent_management_group_id = azurerm_management_group.parent.id

  lifecycle {
    ignore_changes = [parent_management_group_id]
  }
}

resource "azurerm_management_group" "mng_groups_l2" {
  for_each = local.mng_groups_parsed_l2

  display_name = each.value.name
  parent_management_group_id = azurerm_management_group.mng_groups_l1[each.key].id

  lifecycle {
    ignore_changes = [parent_management_group_id]
  }
}