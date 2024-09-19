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
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF

kind create cluster --name k8s-playground --config kind-config.yaml
kubectl cluster-info --context kind-k8s-playground
mkdir .kube/
kind get kubeconfig --name k8s-playground > .kube/config
ls -la .kube
kubectl get nodes
echo "==> End create cluster."

# Install Helm.
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
helm version
echo "==> End install helm."

# Deploy kubernetes dashboard.
kube_dash_name="kubernetes-dashboard"
kubectl create namespace ${kube_dash_name}
kubectl apply -f ${kube_dash_name}-user.yaml -n ${kube_dash_name}
kubectl -n ${kube_dash_name} create token admin-user

echo "*************************."
echo "==> Get token user kubernetes dashboard."
echo "*************************."
kubectl get secret admin-user -n ${kube_dash_name} -o jsonpath={".data.token"} | base64 -d
echo "*************************."
helm repo add ${kube_dash_name} https://kubernetes.github.io/dashboard/
helm upgrade --install ${kube_dash_name} ${kube_dash_name}/${kube_dash_name} --namespace ${kube_dash_name}
echo "==> End deploy kubernetes dashboard."