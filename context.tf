# locals {
#   context_data = yamldecode(file("${path.module}/contexts/platform-dev.yaml"))
# }
# resource "spacelift_context" "managed" {
#   name        = local.context_data.name
#   description = local.context_data.description
#   labels      = local.context_data.labels
# }

# resource "spacelift_environment_variable" "context-plaintext" {

#   for_each = local.context_data.variables

#   context_id = spacelift_context.managed.id
#   name       = each.key
#   value      = each.value
#   write_only = false
# }

locals {
  yaml_files = fileset("${path.module}/contexts", "*.yaml")

  context_data_list = [for file in local.yaml_files : yamldecode(file("${path.module}/contexts/${file}"))]
}

resource "spacelift_context" "managed" {
  for_each = { for i, context in local.context_data_list : i => context }

  name        = each.value.name
  description = each.value.description
  labels      = each.value.labels
}

resource "spacelift_environment_variable" "context-plaintext" {
  for_each = { for context in local.context_data_list : context.name => context.variables }

  context_id = spacelift_context.managed[each.key].id
  name       = each.value.key
  value      = each.value.value
  write_only = false
}
