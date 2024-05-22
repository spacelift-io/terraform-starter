resource "google_storage_bucket" "test" {
  name          = "julian-scalr-poc-test"
  location      = "europe-west1"
  project       = "development-env-ta"
  storage_class = "REGIONAL"
  force_destroy = true
}

