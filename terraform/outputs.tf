output "ec2_public_ip" {
  value = aws_instance.k8s_instance.public_ip
}
