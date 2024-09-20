locals {
  contexts_data = [
    for file in fileset("${path.module}/contexts", "*.yaml") :
    yamldecode(file("${path.module}/contexts/${file}"))
  ]
}
resource "spacelift_context" "managed" {
  for_each = { for context in local.contexts_data : context.name => context }

  name        = each.value["name"]
  description = each.value["description"]
  labels      = each.value["labels"]
}


resource "spacelift_environment_variable" "context-plaintext" {
  for_each = {
    for context in local.contexts_data : context.name => context.variables
    if context.variables != null
  }

  context_id = spacelift_context[each.key].id
  dynamic "variable" {
    for_each = each.value

    content {
      name       = variable.key
      value      = variable.value
      write_only = false
    }
  }
}


