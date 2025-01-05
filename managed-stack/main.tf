variable "spacelift_stack_id" {
  type = string
}

module "main" {
  source = "./components/main"

  env = "${var.spacelift_stack_id}-app"
}

output "env" {
  value = module.main.env
}
