## Keypair name
output "key_name" {
  description = "Name of the generated keypair."
  value = aws_key_pair.generated_key.key_name
}
