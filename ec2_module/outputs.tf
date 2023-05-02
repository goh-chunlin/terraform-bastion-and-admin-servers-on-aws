output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.linux_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance in the VPC."
  value       = aws_instance.linux_server.private_ip
}