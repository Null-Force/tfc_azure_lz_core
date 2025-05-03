variable "parent_mng_group_name" {
  description = "The names of the parent management groups"
  type        = string
  default     = "null_power"

  validation {
    condition     = length(var.parent_mng_group_name) >= 4 && length(var.parent_mng_group_name) <= 30
    error_message = "The parent management group name must be between 4 and 30 characters."
  }
}