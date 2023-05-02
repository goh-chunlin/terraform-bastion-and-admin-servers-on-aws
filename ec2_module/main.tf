resource "aws_instance" "linux_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.is_in_public_subnet
  key_name                    = var.key_name
  vpc_security_group_ids      = [ aws_security_group.linux_server_security_group.id ]
  tags = {
    Name = var.server_name
  }
  user_data = var.user_data
}

resource "aws_security_group" "linux_server_security_group" {
  name         = var.security_group.name
  description  = var.security_group.description
  vpc_id       = var.vpc_id
 
  ingress {
    description = "SSH inbound"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "Allow All egress rule"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = var.security_group.name
  }
}
