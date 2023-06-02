#!/bin/bash
set -eo pipefail

BASE="$(readlink -f "$(dirname $0)")"

(kind get clusters | grep crossplane-demo >/dev/null && echo "Cluster already exists") || kind create cluster --config "$BASE/cluster/kind/cluster.yaml" --kubeconfig kubeconfig.yaml --name crossplane-demo

export KUBECONFIG="$PWD/kubeconfig.yaml"

echo "Configuring ingress" >&2
kubectl kustomize "$BASE/cluster/manifests/ingress" | kubectl apply -f - | sed -E 's/^(.*)$/>> \1/g'

echo "Installing Crossplane"
$BASE/crossplane/install.sh

echo "Installing Crossplane Terraform provider"
$BASE/crossplane/install-terraform-provider.sh
