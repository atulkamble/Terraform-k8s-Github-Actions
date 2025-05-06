#!/bin/bash
# Install K3S - Lightweight Kubernetes

curl -sfL https://get.k3s.io | sh -

# Allow kubectl access
mkdir -p $HOME/.kube
cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
