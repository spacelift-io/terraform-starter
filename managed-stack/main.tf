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