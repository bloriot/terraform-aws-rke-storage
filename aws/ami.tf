data "aws_ami" "sles" {
  most_recent = true

  filter {
    name   = "name"
    values = ["suse-sles-15-sp2-*-hvm-ssd-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["013907871322"] # Amazon
}

