# This resource defines a Spacelift context - a package of reusable
# configuration.
#
# You can read about contexts here:
#
# https://docs.spacelift.io/concepts/context
resource "spacelift_context" "managed" {
  name        = "Managed context"
  description = "Your first context managed by Terraform"
}

# This is an envioronment variable defined on the context level. When the
# context is attached to the stack, this variable will be added to the stack's
# own environment. And that's how we do configuration reuse here at Spacelift.
# This evironment variable has its write_only bit explicitly set to false, which
# means that you'll be able to read back its valie from both the GUI and the API.
#
# You can read more about environment variables here:
#
# https://docs.spacelift.io/concepts/environment#environment-variables
resource "spacelift_environment_variable" "context-plaintext" {
  context_id = spacelift_context.managed.id
  name       = "CONTEXT_PUBLIC"
  value      = "This should be visible!"
  write_only = false
}

# For another (secret) variable, let's create programmatically create a super
# secret password.
resource "random_password" "context-password" {
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
resource "spacelift_environment_variable" "context-writeonly" {
  context_id = spacelift_context.managed.id
  name       = "CONTEXT_SECRET"
  value      = random_password.context-password.result
}

# Apart from setting environment variables in your Contexts, you can add files
# to be mounted directly in Spacelift's workspace. For the purpose of this
# experiment, let's export our environemnt variables as JSON-encoded files, too.
# 
# You can read more about mounted files here: 
#
# https://docs.spacelift.io/concepts/environment#mounted-files
resource "spacelift_mounted_file" "context-plaintext-file" {
  context_id    = spacelift_context.managed.id
  relative_path = "context-plaintext-file.json"
  content = base64encode(jsonencode({
    payload = spacelift_environment_variable.context-plaintext.value
  }))
  write_only = false
}

# Since you can't read back the value from a write-only environment variable
# like we just did that for the read-write one, we'll need to retrieve the value
# of the password directly from its resource.
resource "spacelift_mounted_file" "context-secret-file" {
  context_id    = spacelift_context.managed.id
  relative_path = "context-secret-password.json"
  content       = base64encode(jsonencode({ password = random_password.context-password.result }))
}

# This resource attaches context to a Stack. Since this is many-to-many
# relationship and a single Stack can have multiple contexts attached to it, the
# priority value can be set to indicate the precedence this context should take
# in case of clashes/overrides. The lower the number, the higher the priority.
#
# You can read about attaching and detaching contexts here:
#
# https://docs.spacelift.io/concepts/context#attaching-and-detaching
resource "spacelift_context_attachment" "managed" {
  context_id = spacelift_context.managed.id
  stack_id   = spacelift_stack.managed.id
  priority   = 0
}
