locals {
  context_data = yamldecode(file("${path.module}/contexts/platform-dev.yaml"))
}
resource "spacelift_context" "managed" {
  name        = local.context_data.name
  description = local.context_data.description
  labels      = local.context_data.labels
}

resource "spacelift_environment_variable" "context-plaintext" {

  for_each = local.context_data.variables

  context_id = spacelift_context.managed.id
  name       = each.key
  value      = each.value
  write_only = false
}

resource "spacelift_context_attachment" "managed" {
  context_id = spacelift_context.managed.id
  stack_id   = spacelift_stack.managed.id
  priority   = 0
}
