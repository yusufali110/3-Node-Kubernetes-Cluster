#!/bin/bash

set -e

echo "====================================="
echo " Installing Kubernetes Master"
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

# Kubernetes networking settings
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
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

apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet

# Install Docker separately
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

# Initialize cluster
kubeadm init \
  --apiserver-advertise-address=192.168.56.10 \
  --pod-network-cidr=192.168.0.0/16

# Configure kubectl
mkdir -p /home/vagrant/.kube

cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config

chown -R vagrant:vagrant /home/vagrant/.kube

# Generate worker join command
kubeadm token create --print-join-command > /vagrant/join-command.sh

chmod +x /vagrant/join-command.sh

# Install Calico
sudo -u vagrant kubectl apply \
  -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/calico.yaml

echo "====================================="
echo " Kubernetes Master Ready"
echo "====================================="