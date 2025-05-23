data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}


resource "aws_instance" "cyf-server-ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = "learning"
  security_groups = [aws_security_group.webtrafic.name]

  user_data = <<-EOF
               #!/bin/bash
               mkdir -p /home/ec2-user/.ssh
               echo "sssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1/0qjZvNarDxl3S87sX1h1qWBl2MiE8C+ySdVY+SLKKj4cvT78lkqFBYDNWmlltK+BhFYPqEVrZeT6+JLPbxYrCDXvVaSyTBmz1d8t5sZlC2Gm9bRAcpZy093svME9duCeQGWC6zRolUkkfWZitUDo7bdDTiBYrV5lXz/SG9rYs8l8BnVTuvQ2Kt4POEYm9+hc9ScTJZyCKxSwwqsnHqpuCeDN//htk/EpTs9hzyamAIwOV0V7rFhDcz+VNMf1QKcsSbXNXndm43SYMGLAW6h7r3A7DwHbJyZ+slDJVVNA2p0gjfA+QMSwGED9klZDvgy9XPmETzKAn+eq6rJbgaYtLT3Pe71ckk4274K4aO5J/QE1cnGF7918pdsQJgMk2vkdfvyNO7nrfbxi4izqBjxf40S6t6qk3vqImCCqZc1Y7HtZAJ33YBFibtNDtHfeTG5355ULvfTbBFqwZdtu/FGGtMaelvnTuwDXQCy+G6xbyaDaAwEHBIoL21xlNqrMZjhUq05Yw42iFxDHhKhgrjIonGiTIkt9eZz2vWdpJ5lRL+nsaH6AmGFugIkuxJFP5EWoHtXmAdyx7PctqiV3/WD/w4ajkPuCTW1jKbGI9Y6VWQ56mJ5a4AJSbIfWXbj1SoMGFj2yKUxWJQYdQIg5xiyvVWViEOmH9qO7MWBYO7vjw== boshra@Boshras-MBP-2.lan" >> /home/ec2-user/.ssh/authorized_keys
               chown -R ec2-user:ec2-user /home/ec2-user/.ssh
               chmod 700 /home/ec2-user/.ssh
               chmod 600 /home/ec2-user/.ssh/authorized_keys
               EOF

  tags = {
    Name = "ec2-terraform"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.cyf-server-ec2.id
}
resource "aws_security_group" "webtrafic" {
  name = "allow HTTPS"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}