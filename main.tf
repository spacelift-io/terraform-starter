terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.12.0"
    }
  }
}
