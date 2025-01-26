# This resource here is to show you how plan policies work.

resource "random_password" "secret" {
  length  = 29
  special = true
}

resource "aws_security_group" "example" {
  name        = "vulnerable-sg"
  description = "Allow all traffic"
  vpc_id      = "vpc-12345678"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Insecure: Allows all inbound traffic
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Insecure: Allows all outbound traffic
  }
}

variable "db_password" {
  default = "supersecretpassword" # Misconfiguration: Hardcoded sensitive value
  type    = string
}

output "sensitive_output" {
  value       = var.db_password
  description = "Outputs the database password" # Misconfiguration: Sensitive value exposed in outputs
}

module "vulnerable_module" {
  source  = "./module"
  version = "0.1.0" # Misconfiguration: Versioning might not match the intended module state
}

resource "random_string" "example" {
  length  = 8
  special = true
}

# Sensitive file inclusion
data "local_file" "private_key" {
  filename = "id_rsa" # Misconfiguration: Private key inclusion
}

locals {
  # Insecure use of locals
  insecure_local_value = "not-secure-value" # Sensitive information should not be stored in locals
}