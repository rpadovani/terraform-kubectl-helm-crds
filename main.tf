/*
We use data "http" to download the files, and we use a null resource to check
that we were able to retrieve the files succesfully checking the HTTP return
code
*/

data "http" "yaml_file" {
  for_each = toset(var.crds_links)
  url      = each.value
}

resource "null_resource" "status_check" {
  for_each = toset(var.crds_links)
  provisioner "local-exec" {
    command = contains([200, 201, 204], data.http.yaml_file[each.value].status_code)
  }
}

resource "kubectl_manifest" "crd" {
  for_each = toset(var.crds_links)

  depends_on = [null_resource.status_check]
  yaml_body  = data.http.yaml_file[each.value].response_body

  server_side_apply = var.server_side
}
