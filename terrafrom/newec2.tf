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
               echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiffE2jWSAR1T8/YvxptM6M5F21CjApUMZ8NqcxKPKsrZOdiHJptrXg19TvyiWPZO/0r6zbVnT6lkM400ggcIAaNyhtHO25AENlryfRYdBrvmRjpZcmtzLLHy9uuinOcTJJV0wYY3hkDdxihZ7qy77R/tMkvNN+kZDq0AaqQBoKrVe7lib905+29kdhGut9r6q03ZKkOkSlPsaRcDPf4ADVPDCXM1pfnVqUbVPrlOGFjmJ1G5w1hQGGRDRigLapvIksDrpmNjkSUGjZonrejjrnrFfyHHf9dzXKJDT3ypVx94OSSmbzSu8VBebVbAoWePRRjyNeZM8DZM5e5plFzW9eKjPE5eYdKxr0tbFs6IRSeUkSt/hwvWt6DQiAYHZhU/XRvpJVDVAC4ttmmG21KSj4fffHhk0VjaKkO1XABzDAkbBbLw0pLjxZbEXaSLlYOEW/NaFmz+4lZBygJ+e4fXK/5QXS1vOrG0+UxVTXOckC7hyhTecuTWmy/Itw705/kNJG2j2DNWNNXk+ljv4DXZg9pQPkA8NTr4LDHfh/qgV/XcHHZX4PcDormysHnJ+mEmQNka5D85mp3HuZidFXAuvv9XdATxxIYGXkj5DuxidV8JpNVXvIZhyZ012uJ1ttiw/tQ4y23CnZaY16X4EnFkwPPM2C/tEjyVhDJ1Fr8v8xw== github@ec2" >> /home/ec2-user/.ssh/authorized_keys
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