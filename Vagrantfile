Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"

  # -------------------------
  # Control Plane
  # -------------------------
  config.vm.define "k8s-master" do |master|

    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: "192.168.56.10"

    master.vm.provider "vmware_desktop" do |vmware|
      vmware.vmx["displayName"] = "k8s-master"
      vmware.vmx["memsize"] = "4096"
      vmware.vmx["numvcpus"] = "2"
    end

    master.vm.provision "shell",
      path: "master.sh"

  end

  # -------------------------
  # Worker 1
  # -------------------------
  config.vm.define "k8s-worker1" do |worker|

    worker.vm.hostname = "k8s-worker1"
    worker.vm.network "private_network", ip: "192.168.56.11"

    worker.vm.provider "vmware_desktop" do |vmware|
      vmware.vmx["displayName"] = "k8s-worker1"
      vmware.vmx["memsize"] = "3072"
      vmware.vmx["numvcpus"] = "2"
    end

    worker.vm.provision "shell",
      path: "worker.sh"

  end

  # -------------------------
  # Worker 2
  # -------------------------
  config.vm.define "k8s-worker2" do |worker|

    worker.vm.hostname = "k8s-worker2"
    worker.vm.network "private_network", ip: "192.168.56.12"

    worker.vm.provider "vmware_desktop" do |vmware|
      vmware.vmx["displayName"] = "k8s-worker2"
      vmware.vmx["memsize"] = "3072"
      vmware.vmx["numvcpus"] = "2"
    end

    worker.vm.provision "shell",
      path: "worker.sh"

  end

end