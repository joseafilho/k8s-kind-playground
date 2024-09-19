Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.network "public_network", use_dhcp_assigned_default_route: true, bridge: "wlp3s0"
  
  config.vm.provider "VirtualBox" do |vb|
    vb.name = "kind-poc"
    vb.memory = 2048
    vb.cpus = 1
  end
  
  # Install docker and running simple hello-world.
  config.vm.provision "docker" do |d|
    d.run "hello-world"
  end

  # Copy files.
  config.vm.provision "file", source: "./kubernetes-dashboard-user.yaml", destination: "$HOME/kubernetes-dashboard-user.yaml"
  config.vm.provision "file", source: "./kubernetes-dashboard-ingress.yaml", destination: "$HOME/kubernetes-dashboard-ingress.yaml"
  
  # Run install tools.
  config.vm.provision :shell, path: "bootstrap.sh"
end 
