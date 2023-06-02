#!/bin/bash
set -e

RELEASE=crossplane
NAMESPACE=crossplane-system

helm status -n $NAMESPACE $RELEASE &>/dev/null && echo "Crossplane already installed" && exit 0

kubectl create namespace crossplane-system
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
