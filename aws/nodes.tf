locals {
  cluster_id_tag = {
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}

data "aws_availability_zones" "az" {
}

resource "aws_default_subnet" "default" {
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags              = local.cluster_id_tag
  count             = length(data.aws_availability_zones.az.names)
}

resource "aws_security_group" "allow-all" {
  name        = "rke-default-security-group"
  description = "rke"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.cluster_id_tag
}

resource "aws_instance" "rke-node" {
  count = 4

  ami                    = data.aws_ami.sles.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.rke-node-key.id
  iam_instance_profile   = aws_iam_instance_profile.rke-aws.name
  vpc_security_group_ids = [aws_security_group.allow-all.id]

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 20
  }

  provisioner "remote-exec" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.node-key.private_key_pem
    }

    inline = [
      "sudo usermod -a -G docker ec2-user",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
    ]
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_id}" = "owned",
    Name  = "rke-node-${count.index + 1}",
  }
}

