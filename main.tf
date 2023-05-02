module "vpc" {
  source          = "./vpc_module"
  resource_prefix = var.resource_prefix
}
  
module "keypair" {
  source              = "./keypair_module"
  keypair_name        = "my_keypair"
}
    
module "ec2_bastion" {
  source              = "./ec2_module"
  ami                 = "ami-062550af7b9fa7d05"       # Ubuntu 20.04 LTS (HVM), SSD Volume Type
  instance_type       = "t2.micro"
  server_name         = "bastion_server"
  subnet_id           = module.vpc.public_subnet_ids[0]
  is_in_public_subnet = true
  key_name            = module.keypair.key_name
  security_group      = {
    name        = "bastion_sg"
    description = "This firewall allows SSH"
  }
  vpc_id              = module.vpc.vpc_id
}
    
module "ec2_admin" {
  source              = "./ec2_module"
  ami                 = "ami-062550af7b9fa7d05"       # Ubuntu 20.04 LTS (HVM), SSD Volume Type
  instance_type       = "t2.micro"
  server_name         = "admin_server"
  subnet_id           = module.vpc.private_subnet_ids[0]
  is_in_public_subnet = false
  key_name            = module.keypair.key_name
  security_group      = {
    name        = "admin_sg"
    description = "This firewall allows SSH"
  }
  user_data           = "${file("admin_server_init.sh")}"
  vpc_id              = module.vpc.vpc_id
  depends_on          = [module.vpc.aws_route_table_association]
}
