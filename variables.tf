variable "crds_urls" {
  type        = list(string)
  description = "List of the URLs where custom resource definitions are declared."
}

variable "force_new" {
  type        = bool
  default     = false
  description = "Optional. Forces delete & create of resources if the yaml_body changes. Default false."
}

variable "server_side_apply" {
  type        = bool
  default     = false
  description = "Optional. Allow using server-side-apply method. Default false."
}

variable "force_conflicts" {
  type        = bool
  default     = false
  description = "Optional. Allow using force_conflicts. Default false."
}

variable "apply_only" {
  type        = bool
  default     = false
  description = "Optional. When set to true, the module won't ever delete a CRD. Default false."
}
