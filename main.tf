data "azurerm_subscription" "current" {}



variable "parent_mng_group_name" {
  description = "The names of the parent management groups"
  type        = string
  default     = "null_power"

  # Validation to ensure names meet Azure naming requirements
  validation {
    condition = alltrue([
      for name in var.parent_mng_group_name : 
      can(regex("^[a-z0-9-_]+$", name)) &&  # Only lowercase alphanumeric, underscores
      length(name) >= 3 &&  # Minimum length
      length(name) <= 30    # Maximum length for management group names
    ])
    error_message = "Management group names must be 3-30 characters long, containing only alphanumeric characters and underscores."
  }
}

variable "mng_groups_names" {
  description = "The names of the management groups"
  type        = string
  default     = "{\"platform\":[\"management\",\"identity\",\"connectivity\"],\"landing_zones\":[\"corporate\",\"online\"],\"decommissioned\":[],\"sandbox\":[]}"
}


locals {
  parent_mng_group_name = var.parent_mng_group_name
  mng_groups_parsed = jsondecode(var.mng_groups_names)
  mng_groups_map = {
    for group, names in local.mng_groups_parsed : 
    group => [
      for name in names : 
      {
        name = name
        group = group
      }
    ]
  }

}


resource "azurerm_management_group" "parent" {  
  display_name = local.parent_mng_group_name
}

resource "azurerm_management_group" "mng_groups_l1" {
  for_each = local.mng_groups_map

  display_name = each.key
  parent_management_group_id = azurerm_management_group.parent.id

  lifecycle {
    ignore_changes = [parent_management_group_id]
  }
}

resource "azurerm_management_group" "mng_groups_l2" {
  for_each = local.mng_groups_map

  display_name = each.value.name
  parent_management_group_id = azurerm_management_group.mng_groups_l1[each.value.group].id

  lifecycle {
    ignore_changes = [parent_management_group_id]
  }
}