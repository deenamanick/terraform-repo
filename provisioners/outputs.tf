output "instance_public_ip" {
  value = aws_instance.web-server-02.public_ip
}

output "private_key_pem" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true # Hides the private key from logs
}