locals {
  yaml_files = fileset("${path.module}/contexts", "*.yaml")

  context_data_list = [for file in local.yaml_files : yamldecode(file("${path.module}/contexts/${file}"))]

  flattened_variables = flatten([for context in local.context_data_list : [
    for var_key, var_value in context.variables : {
      context_id = context.name
      name       = var_key
      value      = var_value
    }
  ]])
}

resource "spacelift_context" "managed" {
  for_each = { for i, context in local.context_data_list : context.name => context }

  name        = each.key
  description = each.value.description
  labels      = each.value.labels
}

resource "spacelift_environment_variable" "context-plaintext" {
  for_each = { for idx, context in local.flattened_variables : "${context.context_id}-${context.name}" => context }

  context_id = spacelift_context.managed[each.value.context_id].id
  name       = each.value.name
  value      = each.value.value
  write_only = false
}
