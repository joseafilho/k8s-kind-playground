Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.network "public_network", use_dhcp_assigned_default_route: true, bridge: "wlp3s0"
  config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 80, host: 8080, id: "k8s-http"
  config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 443, host: 8443, id: "k8s-https"
  
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
  config.vm.provision "file", source: "./http-echo/http-echo.yaml", destination: "$HOME/http-echo.yaml"

  # config.vm.provision "file", source: "./kubernetes-dashboard/kubernetes-dashboard-user.yaml", destination: "$HOME/kubernetes-dashboard-user.yaml"
  # config.vm.provision "file", source: "./kubernetes-dashboard/kubernetes-dashboard-ingress.yaml", destination: "$HOME/kubernetes-dashboard-ingress.yaml"
  # config.vm.provision "file", source: "./http-echo/http-echo-ingress.yaml", destination: "$HOME/http-echo-ingress.yaml"
  # config.vm.provision "file", source: "./ingress/ingress.yaml", destination: "$HOME/ingress.yaml"
  # config.vm.provision "file", source: "./wait-running.sh", destination: "$HOME/wait-running.sh"
  
  # Run install tools.
  config.vm.provision :shell, path: "bootstrap.sh"
end 
