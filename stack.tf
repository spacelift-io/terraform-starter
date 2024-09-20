data "spacelift_current_stack" "this" {}

resource "spacelift_stack" "root_admin_stack" {
  name        = "Root Admin Stack"
  description = "Root Admin Stack for CloudOps used for managing spaces and contexts. DO NOT DELETE."

  repository   = "cloudops-spacelift-admin-stack"
  branch       = "main"
  project_root = "managed-stack"

  autodeploy = true
  labels     = ["managed", "depends-on:${data.spacelift_current_stack.this.id}"]
}