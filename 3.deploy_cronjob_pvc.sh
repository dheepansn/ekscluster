#!/bin/bash
set -x
### To Load KUBECONFIG File to your Home Directory ###
aws eks --region $(terraform output -state=sph-eks-cluster/terraform.tfstate -raw region) update-kubeconfig \
    --name $(terraform output -state=sph-eks-cluster/terraform.tfstate -raw cluster_name)

### To create cronjob and pvc claims ###
kubectl apply -f yamls/cronjob.yaml
kubectl apply -f yamls/pvc.yaml

