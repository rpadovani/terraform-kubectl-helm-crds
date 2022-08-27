variable "crds_urls" {
  type        = list(string)
  description = "List of the URLs where custom resource definitions are declared."
}

variable "server_side_apply" {
  type        = bool
  default     = false
  description = "Optional. Allow using server-side-apply method. Default false."
}
