#! /bin/bash
az aks get-credentials --name k8s_vanek-aks --resource-group k8s_vanek-rg
kustomize build dev | kubectl apply -f -
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yamlhel
#kubectl apply -f .\persistenVolumeClaim.yaml -n dev
#kubectl apply -f .\pod1.yaml -n dev
#kubectl apply -f .\pod2.yaml -n dev
#kubectl apply -f .\pod3.yaml -n dev
az aks update -n k8s_vanek-aks -g k8s_vanek-rg --attach-acr vanekCR