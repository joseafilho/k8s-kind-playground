#!/bin/bash

# Install kubectl.
sudo apt update && sudo apt install -y apt-transport-https
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
echo "==> End installing kubectl."

# Install kind.
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version
echo "==> End installing kind."

# Create cluster.
cat > kind-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 31437
    hostPort: 8081
    protocol: TCP
  - containerPort: 31438
    hostPort: 8444
    protocol: TCP
- role: worker
- role: worker
EOF

## Connect kubectl.
kind create cluster --name k8s-playground --config kind-config.yaml
kubectl cluster-info --context kind-k8s-playground
mkdir .kube/
kind get kubeconfig --name k8s-playground > .kube/config
kubectl get nodes
sleep 2 # Wait start cluster.
echo "==> End create cluster."

# Install Gateway api nginx.
kubectl kustomize "https://github.com/nginxinc/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.4.0" | kubectl apply -f -
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/nodeport/deploy.yaml
kubectl apply -f gateway.yaml
kubectl apply -f gateway-svc.yaml
# kubectl apply -f gateway-route.yaml
echo "==> End Install apigateway api nginx."

# Deploy apps https echo.
kubectl apply -f http-echo.yaml
echo "==> End Deploy apps https echo."

# Install Helm.
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
helm version
echo "==> End install helm."

# Deploy kubernetes dashboard.
# kube_dash_name="kubernetes-dashboard"
# kubectl create namespace ${kube_dash_name}
# kubectl apply -f ${kube_dash_name}-user.yaml -n ${kube_dash_name}
# kubectl -n ${kube_dash_name} create token admin-user; echo
# kubectl apply -f ${kube_dash_name}-gateway-refg.yaml -n ${kube_dash_name}

# echo "*************************."
# echo "==> Get token user kubernetes dashboard."
# echo "*************************."
# kubectl get secret admin-user -n ${kube_dash_name} -o jsonpath={".data.token"} | base64 -d
# echo "*************************."
# helm repo add ${kube_dash_name} https://kubernetes.github.io/dashboard/
# helm upgrade --install ${kube_dash_name} ${kube_dash_name}/${kube_dash_name} --namespace ${kube_dash_name} # --set ingress.enabled=true --set ingress.path='/kube-dash' # --set kong.proxy.type=NodePort --set kong.http.enable=true
# echo "==> End deploy kubernetes dashboard."

# Deploy gateway route.
kubectl apply -f gateway-route.yaml
echo "==> End Deploy gateway route."

# Validatind apps https echo.
curl localhost:8081/dev-app; echo
curl localhost:8081/ops-app; echo
curl localhost:8081/ops-app-v2; echo
echo "==> End Validating apps https echo."

# # Deploy ingress
# # kubectl apply -f ingress.yaml
# # echo "==> Waiting ingress 60 seconds."
# # sleep 90

# # Deploy apps https echo.
# kubectl apply -f http-echo.yaml
# sleep 90
# curl localhost/dev-app; echo
# curl localhost/ops-app; echo
# echo "==> End Validating ingress NGinx."

# # Ingress status.
# kubectl describe ingress -n hello-app
# kubectl describe ingress -n ${kube_dash_name}
# echo "==> End ingress status."