resource "aws_instance" "k8s_instance" {
  ami           = "ami-0b86aaed8ef90e45f" # Amazon Linux 2
  instance_type = "t2.medium"
  key_name      = "key" # Replace with your actual EC2 key pair name

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Install K3s without SELinux RPM to avoid dependency issues
              curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true sh -

              # Copy K3s kubeconfig for external access
              cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/kubeconfig.yaml
              chown ec2-user:ec2-user /home/ec2-user/kubeconfig.yaml
              chmod 600 /home/ec2-user/kubeconfig.yaml

              echo "✅ K3s installed and kubeconfig ready."
              git clone https://github.com/Samiksha998/project.git
              cd project
              kubectl --kubeconfig=../kubeconfig.yaml apply -f ./k8s-manifests
              echo "✅ hosted app on k8s server."

              EOF

  tags = {
    Name = "k8s-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "for i in {1..12}; do",
      "  [ -f /home/ec2-user/kubeconfig.yaml ] && break",
      "  echo 'Waiting for kubeconfig...'; sleep 10;",
      "done",
      "[ -f /home/ec2-user/kubeconfig.yaml ] || (echo '❌ kubeconfig.yaml not found'; sudo cat /var/log/cloud-init-output.log; exit 1)",
      "echo '✅ kubeconfig.yaml is present.'"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/key.pem")
      host        = aws_instance.k8s_instance.public_ip
    }
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.k8s_instance.id
  allocation_id = "eipalloc-030bfd53db39d9735" # Replace with your actual EIP allocation ID
}

output "instance_public_ip" {
  value = aws_instance.k8s_instance.public_ip
}
