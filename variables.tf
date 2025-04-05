variable "parent_mng_group_name" {
  description = "The names of the parent management groups"
  type        = string
  default     = "null_power"

  validation {
    condition     = length(var.parent_mng_group_name) >= 4 && length(var.parent_mng_group_name) <= 30
    error_message = "The parent management group name must be between 4 and 30 characters."
  }
}

variable "mng_groups_names" {
  description = "The names of the management groups"
  type        = string
  default     = "{\"platform\":[\"management\",\"identity\",\"connectivity\"],\"landing_zones\":[\"corporate\",\"online\"],\"decommissioned\":[],\"sandbox\":[]}"

  validation {
    condition     = can(jsondecode(var.mng_groups_names))
    error_message = "The management group names must be a valid JSON string. Default value is: {\"platform\":[\"management\",\"identity\",\"connectivity\"],\"landing_zones\":[\"corporate\",\"online\"],\"decommissioned\":[],\"sandbox\":[]}"
  }
}