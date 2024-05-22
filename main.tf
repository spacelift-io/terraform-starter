terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.12.0"
    }
  }
  backend "remote" {
    hostname     = "jdrodriguezrui.scalr.io"
    organization = "env-v0oc1t0l0nsmbkvfb"

    workspaces {
      name = "test"
    }
  }
}

