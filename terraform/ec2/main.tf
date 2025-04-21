data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.project_name}-${var.environment}-instance-sg"
  description = "Security group for ${var.project_name} EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.whitelist_ips
  }

  ingress {
    description = "Mongodb from anywhere"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "S3 self-hosted from anywhere"
    from_port   = 4566
    to_port     = 4566
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-instance-sg"
  }
}


resource "aws_instance" "vps" {
  count         = var.instance_count
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  monitoring = var.enable_monitoring

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-${count.index + 1}"
  }
}

resource "aws_eip" "eip" {
  count  = var.instance_count
  domain = "vpc"

  instance = aws_instance.vps[count.index].id

  tags = {
    Name = "${var.project_name}-${var.environment}-eip-${count.index + 1}"
  }
}
