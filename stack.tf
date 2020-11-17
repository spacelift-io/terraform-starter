data "spacelift_current_stack" "this" {}

resource "spacelift_stack" "managed" {
  name        = "Managed stack"
  description = "Your first stack managed by Terraform"

  repository   = "terraform-starter"
  branch       = "main"
  project_root = "managed-stack"

  autodeploy = true
  labels     = ["managed", "depends-on:${data.spacelift_current_stack.this.id}"]
}

# This is an environment variable defined on the stack level. Stack-level
# environment variables take precedence over those attached via contexts.
# This evironment variable has its write_only bit explicitly set to false, which
# means that you'll be able to read back its valie from both the GUI and the API.
#
# You can read more about environment variables here:
#
# https://docs.spacelift.io/concepts/environment#environment-variables
resource "spacelift_environment_variable" "stack-plaintext" {
  stack_id   = spacelift_stack.managed.id
  name       = "STACK_PUBLIC"
  value      = "This should be visible!"
  write_only = false
}

# For another (secret) variable, let's create programmatically create a super
# secret password.
resource "random_password" "stack-password" {
  length  = 32
  special = true
}

# This is a secret environment variable. Note how we didn't set the write_only
# bit at all here. This setting always defaults to "true" to protect you against
# an accidental leak of secrets. There will be no way to retrieve the value of
# this variable programmatically, but it will be available to your Spacelift
# runs.
#
# If you accidentally print it out to the logs, no worries: we will obfuscate
# every secret thing we know of.
resource "spacelift_environment_variable" "stack-writeonly" {
  stack_id = spacelift_stack.managed.id
  name     = "STACK_SECRET"
  value    = random_password.stack-password.result
}

# Apart from setting environment variables on your Stacks, you can mount files
# directly in Spacelift's workspace. Let's retrieve the list of Spacelift's
# outgoing addresses and store it as a JSON file.
data "spacelift_ips" "ips" {}

# This mounted file contains a JSON-encoded list of Spacelift's outgoing IPs.
# Note how we explicitly set the "write_only" bit for this file to "false".
# Thanks to that, you can download the file from the Spacelift GUI.
#
# You can read more about mounted files here: 
#
# https://docs.spacelift.io/concepts/environment#mounted-files
resource "spacelift_mounted_file" "stack-plaintext-file" {
  stack_id      = spacelift_stack.managed.id
  relative_path = "stack-plaintext-ips.json"
  content       = base64encode(jsonencode(data.spacelift_ips.ips.ips))
  write_only    = false
}

# Mounted-files can be write-only, too, and they are by default. The content of
# write-only mounted files cannot be accessed neither from the GUI nor from the
# GraphQL API.
resource "spacelift_mounted_file" "stack-secret-file" {
  stack_id      = spacelift_stack.managed.id
  relative_path = "stack-secret-password.json"
  content       = base64encode(jsonencode({ password = random_password.stack-password.result }))
}
