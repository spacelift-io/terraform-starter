# This resource here is to show you how plan policies work.

resource "random_password" "secret" {
  length  = 6
  special = true
}
