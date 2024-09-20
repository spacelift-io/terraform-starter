data "yaml_file" "contexts" {

  for_each = fileset("${path.module}/contexts", "*.yaml")

  filename = each.value
}
resource "spacelift_context" "managed" {

  count = length(data.yaml_file.contexts)

  name        = data.yaml_file.instances[count.index].content["name"]
  description = data.yaml_file.instances[count.index].content["description"]
  labels      = data.yaml_file.instances[count.index].content["labels"]
}

# resource "spacelift_environment_variable" "context-plaintext" {

#   for_each = local.context_data

#   context_id = spacelift_context.managed.id
#   name       = each.key
#   value      = each.value
#   write_only = false
# }
