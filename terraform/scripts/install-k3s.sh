#!/bin/bash

# Enable full logging
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "🟢 Starting K3s installation..."

# Install K3s
curl -sfL https://get.k3s.io | sh -

# Wait to ensure K3s service and kubeconfig are ready
sleep 30

echo "📁 Copying kubeconfig to ec2-user home..."
sudo cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/kubeconfig.yaml
sudo chown ec2-user:ec2-user /home/ec2-user/kubeconfig.yaml
sudo chmod 600 /home/ec2-user/kubeconfig.yaml

# Export KUBECONFIG for current session and add to .bashrc
echo 'export KUBECONFIG=~/kubeconfig.yaml' >> /home/ec2-user/.bashrc
export KUBECONFIG=/home/ec2-user/kubeconfig.yaml

echo "✅ kubeconfig.yaml is set and permissions applied."

# Check K3s service status
echo "🔍 Checking K3s service..."
sudo systemctl status k3s | grep Active

# Wait a few seconds before running kubectl
sleep 5

# Output cluster info
echo "📡 Kubernetes Cluster Info:"
/usr/local/bin/kubectl --kubeconfig=/home/ec2-user/kubeconfig.yaml cluster-info || echo "❌ Failed to get cluster info"

# List nodes
echo "🧩 Listing Kubernetes Nodes:"
/usr/local/bin/kubectl --kubeconfig=/home/ec2-user/kubeconfig.yaml get nodes || echo "❌ Failed to list nodes"
