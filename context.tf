locals {
  contexts_data = [
    for file in fileset("${path.module}/contexts", "*.yaml") :
    yamldecode(file("${path.module}/contexts/${file}"))
  ]
}
resource "spacelift_context" "managed" {

  count = length(local.contexts_data)

  name        = local.contexts_data[count.index].content["name"]
  description = local.contexts_data[count.index].content["description"]
  labels      = local.contexts_data[count.index].content["labels"]
}

# resource "spacelift_environment_variable" "context-plaintext" {

#   for_each = local.context_data

#   context_id = spacelift_context.managed.id
#   name       = each.key
#   value      = each.value
#   write_only = false
# }
