helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kong https://charts.konghq.com
helm repo add stable https://charts.helm.sh/stable
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install kong/kong --generate-name --set ingressController.installCRDs=false
kubectl create ns dev
helm install nginx-ingress nginx-stable/nginx-ingress
helm install default-ingress kong/kong -n ingress 
helm install prometheus prometheus-community/kube-prometheus-stack