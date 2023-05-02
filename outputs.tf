### Bastion server
output "bastion_public_ip" {
  description = "The Public IPv4 address of the bastion server."
  value       = module.ec2_bastion.instance_public_ip
}

### Admin server
output "admin_private_ip" {
  description = "The Private IPv4 address of the admin server."
  value       = module.ec2_admin.instance_private_ip
}