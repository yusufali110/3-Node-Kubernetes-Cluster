# 3-Node Kubernetes Cluster using Vagrant and VMware

## Overview
Kubernetes cluster configuration using Vagrant, VMware and Ubuntu 22.04.

## Architecture
- k8s-master: 192.168.56.10 (4 GB RAM, 2 CPU)
- k8s-worker1: 192.168.56.11 (3 GB RAM, 2 CPU)
- k8s-worker2: 192.168.56.12 (3 GB RAM, 2 CPU)

## Technologies
- Vagrant and VMware
- Ubuntu 22.04
- Kubernetes kubeadm, kubelet, kubectl
- containerd
- Calico CNI

## Files
- Vagrantfile: VM configuration
- master.sh: Kubernetes control plane setup
- worker.sh: Kubernetes worker setup

## Prerequisites
- Windows, VMware Workstation and Vagrant
- VMware provider plugin

## Start Cluster
```bash
vagrant up --provider=vmware_desktop
```

## Check Status
```bash
vagrant status
```

## Important Notes
Kubernetes version configured: v1.30. Cluster provisioning has not yet been verified.

## Author
Yusuf Khayyat
