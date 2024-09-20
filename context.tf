locals {
  context_data = fileset("${path.module}/contexts", "*.yaml")
}
resource "spacelift_context" "managed" {

  for_each = local.context_data

  name        = yamldecode(file(each.value)).name
  description = yamldecode(file(each.value)).description
  labels      = yamldecode(file(each.value)).labels
}

# resource "spacelift_environment_variable" "context-plaintext" {

#   for_each = local.context_data

#   context_id = spacelift_context.managed.id
#   name       = each.key
#   value      = each.value
#   write_only = false
# }
