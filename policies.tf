resource "spacelift_policy" "login" {
  type = "LOGIN"

  name = "Enable login for Oolessence.io workforce"
  body = file("${path.module}/policies/login.rego")
}

# Access policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "login" {
  policy_id = spacelift_policy.login.id
  stack_id  = spacelift_stack.managed.id
}

resource "spacelift_policy" "push" {
  type = "GIT_PUSH"

  name = "Ignore commits outside the project root"
  body = file("${path.module}/policies/push.rego")
}

resource "spacelift_policy_attachment" "push" {
  policy_id = spacelift_policy.push.id
  stack_id  = spacelift_stack.managed.id
}

resource "spacelift_policy" "trigger" {
  type = "TRIGGER"

  name = "Trigger stacks that declare an explicit dependency"
  body = file("${path.module}/policies/trigger.rego")
}

resource "spacelift_policy_attachment" "trigger" {
  policy_id = spacelift_policy.trigger.id
  stack_id  = spacelift_stack.managed.id
}

resource "spacelift_policy_attachment" "trigger-self" {
  policy_id = spacelift_policy.trigger.id
  stack_id  = data.spacelift_current_stack.this.id
}
