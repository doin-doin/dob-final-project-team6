# sg.tf
resource "aws_security_group" "OpenSG_443" {
  name        = "443openSG"
  description = "Allow 443 HTTP"
  # vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "For http port"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "For http port"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  tags = {
    "Name" = "SecurityGroup_443",
    "TEST" = "SecurityGroup_443"
  }
}