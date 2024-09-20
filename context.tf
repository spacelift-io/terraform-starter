locals {
  contexts_data = [
    for file in fileset("${path.module}/contexts", "*.yaml") :
    yamldecode(file("${path.module}/contexts/${file}"))
  ]
}
resource "spacelift_context" "managed" {

  count = length(local.contexts_data)

  name        = local.contexts_data[count.index]["name"]
  description = local.contexts_data[count.index]["description"]
  labels      = local.contexts_data[count.index]["labels"]
}

resource "spacelift_environment_variable" "context-plaintext" {
  for_each = { 
    for context in local.contexts_data : 
    "${context.name}-${context.variables["env"]}" => context.variables 
    if context.variables != null 
  }

  context_id = spacelift_context[each.key].managed.id
  name       = each.value["name"]
  value      = each.value
  write_only = false
}
