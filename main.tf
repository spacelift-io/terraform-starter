variable "spacelift_key_id" {}
variable "spacelift_key_secret" {}

terraform {
  required_providers {
    spacelift = {
      source = "spacelift.io/spacelift-io/spacelift"
    }
  }
}

provider "spacelift" {}

provider "spacelift" {
  alias = "external"

  api_key_enpdoint = "https://spacelift-io.app.spacelift.dev"
  api_key_id       = var.spacelift_key_id
  api_key_secret   = var.spacelift_key_secret
}

resource "spacelift_context" "managed" {
  provider = spacelift.external
  name     = "Externally created context"
}
