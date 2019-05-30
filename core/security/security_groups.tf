data "aws_vpc" "vpc_core" { tags { Name = "natureofclouds-core-vpc" }}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id     = "${data.aws_vpc.vpc_core.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "natureofclouds-${var.env}-allow-ssh-sg"
    Env = "${var.env}"
  }
}