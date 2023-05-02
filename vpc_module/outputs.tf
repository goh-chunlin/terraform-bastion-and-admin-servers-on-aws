## VPC_ID
output "vpc_id" {
  description = "Contains the VPC ID"
  value = aws_vpc.my_simple_vpc.id
}

## Public Subnet IDs
output "public_subnet_ids" {
  description = "Contains the public IDs"
  value = [aws_subnet.public.*.id[0]]
}

## Private Subnet IDs
output "private_subnet_ids" {
  description = "Contains the private subnet IDs"
  value = [aws_subnet.private.*.id[0]]
}

## Private Route Table Association ID
output "private_route_id" {
  description = "Contains the private_route ID"
  value = aws_route_table_association.private_route[0].id
}
