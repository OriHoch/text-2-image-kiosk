locals {
  region = "eu-west-1"
  vpc_cidr_block = "172.31.0.0/16"
  name = "text-2-image-kiosk"
  subnet_cidr_block = "172.31.0.0/20"
  subnet_availability_zone = "a"
  # 4 vCPU, 1 GPU, 16 GB RAM, 125 GB instance volume
  api_instance_type = "g4dn.xlarge"
  # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-09-12
  api_ami = "ami-096800910c1b781ba"
}

terraform {
  backend "local" {}
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "aws" {
  region = local.region
}

variable "cloudflare_api_token" {
  type = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block
  tags = {
    Name = "${local.name}-main"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = local.subnet_cidr_block
  availability_zone = "${local.region}${local.subnet_availability_zone}"
  tags = {
    Name = "${local.name}-main-${local.subnet_availability_zone}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name}-public"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
      Name = "${local.name}-main"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_key_pair" "main" {
  public_key = "${file("~/.ssh/id_rsa.pub")}"
  key_name = "${local.name}-main"
  tags = {
    Name = "${local.name}-main"
  }
}

resource "aws_security_group" "api" {
    name = "${local.name}-api"
    vpc_id = aws_vpc.main.id
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "api" {
  instance_type = local.api_instance_type
  ami = local.api_ami
  key_name = aws_key_pair.main.key_name
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.api.id]
  root_block_device {
    volume_size = 50
  }
  monitoring = false
  tags = {
    Name = "${local.name}-api"
  }
  tenancy = "default"
}

output "api_public_ip" {
  value = aws_instance.api.public_ip
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_instance.api.public_ip}"
}

resource "null_resource" "ansible_inventory" {
  triggers = {
      api_public_ip = aws_instance.api.public_ip
  }
  provisioner "local-exec" {
      command = <<-EOT
        mkdir -p .ansible
        echo "
        virtualmachines:
          hosts:
            api:
              ansible_host: ${aws_instance.api.public_ip}
              ansible_user: ubuntu
        " > .ansible/inventory.yaml
      EOT
  }
}

variable "main_root_domain" {
  type = string
}

data "cloudflare_zone" "main" {
  name = var.main_root_domain
}

resource "cloudflare_record" "api" {
  zone_id = data.cloudflare_zone.main.id
  name = "t2ik-sd-api"
  value = aws_instance.api.public_ip
  type = "A"
  proxied = true
}
