resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name = var.keypair_name
  public_key = tls_private_key.instance_key.public_key_openssh
  depends_on = [
    tls_private_key.instance_key
  ]
}

resource "local_file" "key" {
  content = tls_private_key.instance_key.private_key_pem
  filename = "${var.keypair_name}.pem"
  file_permission ="0400"
  depends_on = [
    tls_private_key.instance_key
  ]
}
