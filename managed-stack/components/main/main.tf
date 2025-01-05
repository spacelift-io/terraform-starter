resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo 'Hello env ${var.env}'"
  }
}

resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "echo 'Hello env ${var.env}'"
  }
}
