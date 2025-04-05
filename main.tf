# Creage a management groups
# New root management group
resource "azurerm_management_group" "parent" {
  display_name = local.parent_mng_group_name
}

# L1 management groups
resource "azurerm_management_group" "mng_groups_l1" {
  for_each = local.mng_groups_parsed_l1

  display_name               = each.key
  parent_management_group_id = azurerm_management_group.parent.id

  lifecycle {
    ignore_changes = [parent_management_group_id]
  }
}

# L2 management groups
resource "azurerm_management_group" "mng_groups_l2" {
  for_each = local.mng_groups_parsed_l2

  display_name               = each.value.name
  parent_management_group_id = azurerm_management_group.mng_groups_l1[each.value.group].id

  lifecycle {
    ignore_changes = [parent_management_group_id]
  }
}