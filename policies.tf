# ACCESS POLICY
#
# This example access policy gives everyone in the "Engineering" GitHub team
# read access to the stack.
#
# You can read more about access policies here:
#
# https://docs.spacelift.io/concepts/policy/stack-access-policy
resource "spacelift_policy" "access" {
  type = "ACCESS"

  name = "All of Engineering gets read access"
  body = file("${path.module}/policies/access.rego")
}

# Access policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "access" {
  policy_id = spacelift_policy.access.id
  stack_id  = spacelift_stack.managed.id
}

# PLAN POLICY
#
# This example plan policy prevents you from creating weak passwords, and warns 
# you when passwords are meh.
#
# You can read more about plan policies here:
#
# https://docs.spacelift.io/concepts/policy/terraform-plan-policy
resource "spacelift_policy" "plan" {
  type = "PLAN"

  name = "Enforce password strength"
  body = file("${path.module}/policies/plan.rego")
}

# Plan policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "plan" {
  policy_id = spacelift_policy.plan.id
  stack_id  = spacelift_stack.managed.id
}

# PUSH POLICY
#
# This example Git push policy ignores all changes that are outside a project's
# root. Other than that, it follows the defaults - pushes to the tracked branch
# trigger tracked runs, pushes to all other branches trigger proposed runs, tag
# pushes are ignored.
#
# You can read more about push policies here:
#
# https://docs.spacelift.io/concepts/policy/git-push-policy
resource "spacelift_policy" "push" {
  type = "GIT_PUSH"

  name = "Ignore commits outside the project root"
  body = file("${path.module}/policies/push.rego")
}

# Push policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "push" {
  policy_id = spacelift_policy.push.id
  stack_id  = spacelift_stack.managed.id
}

# TASK POLICY
#
# This task policy only allows you to exectute a few selected commands.
#
# You can read more about task policies here:
#
# https://docs.spacelift.io/concepts/policy/task-run-policy
resource "spacelift_policy" "task" {
  type = "TASK"

  name = "Allow only safe commands"
  body = file("${path.module}/policies/task.rego")
}

# Task policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "task" {
  policy_id = spacelift_policy.task.id
  stack_id  = spacelift_stack.managed.id
}

# TRIGGER POLICY
#
# This example trigger policy will cause every stack that declares dependency on
# the current one to get triggered the current one is successfully updated.
#
# You can read more about trigger policies here:
#
# https://docs.spacelift.io/concepts/policy/trigger-policy
resource "spacelift_policy" "trigger" {
  type = "TRIGGER"

  name = "Trigger stacks that declare an explicit dependency"
  body = file("${path.module}/policies/trigger.rego")
}

# Trigger policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "trigger" {
  policy_id = spacelift_policy.trigger.id
  stack_id  = spacelift_stack.managed.id
}

# Let's attach the policy to the current stack, so that the child stack is
# triggered, too.
resource "spacelift_policy_attachment" "trigger-self" {
  policy_id = spacelift_policy.trigger.id
  stack_id  = data.spacelift_current_stack.this.id
}

# LOGIN POLICY
#
# This example login policy gives everyone in the GitHub organization access to
# Spacelift and makes all members of the GitHub "DevOps" team admins.
#
# Note that unlike all other policies, login policies operate on the global
# level and are not attached to individual stacks.
#
# You can read more about login policies here:
#
# https://docs.spacelift.io/concepts/policy/login-policy
resource "spacelift_policy" "login" {
  type = "LOGIN"

  name = "DevOps are admins"
  body = file("${path.module}/policies/login.rego")
}
