Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.network "public_network", use_dhcp_assigned_default_route: true, bridge: "wlp3s0"
  config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 8081, host: 8081, id: "k8s-http"
  config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 8444, host: 8444, id: "k8s-https"
  
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
  config.vm.provision "file", source: "./gateway/gateway.yaml", destination: "$HOME/gateway.yaml"
  config.vm.provision "file", source: "./gateway/gateway-svc.yaml", destination: "$HOME/gateway-svc.yaml"
  config.vm.provision "file", source: "./gateway/gateway-route.yaml", destination: "$HOME/gateway-route.yaml"
  config.vm.provision "file", source: "./kubernetes-dashboard/kubernetes-dashboard-gateway-refg.yaml", destination: "$HOME/kubernetes-dashboard-gateway-refg.yaml"
  config.vm.provision "file", source: "./http-echo/http-echo.yaml", destination: "$HOME/http-echo.yaml"
  
  # Run install tools.
  config.vm.provision :shell, path: "bootstrap.sh"
end 
