#!/bin/bash

set -e

echo "====================================="
echo " Installing Kubernetes Worker"
echo "====================================="

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Kernel modules
cat <<EOF > /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Kubernetes networking
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Install required packages
apt-get update

apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gpg \
  containerd

# Configure containerd
mkdir -p /etc/containerd

containerd config default > /etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' \
  /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# Kubernetes repository
mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' \
  > /etc/apt/sources.list.d/kubernetes.list

apt-get update

apt-get install -y kubelet kubeadm

apt-mark hold kubelet kubeadm

systemctl enable kubelet

# Install Docker separately
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

# Wait for master join command
echo "Waiting for Kubernetes master..."

while [ ! -f /vagrant/join-command.sh ]
do
    sleep 5
done

# Join cluster
bash /vagrant/join-command.sh

echo "====================================="
echo " Worker Joined Kubernetes Cluster"
echo "====================================="