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

