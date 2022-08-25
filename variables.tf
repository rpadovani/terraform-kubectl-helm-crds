variable "crds_links" {
  type        = list(string)
  description = "List of the custom resource definitions we need to manage"
}

variable "server_side" {
  type    = bool
  default = false
}
