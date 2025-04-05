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