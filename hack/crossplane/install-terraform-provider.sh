#!/bin/bash
set -eo pipefail

BASE="$(readlink -f "$(dirname $0)")"

kubectl apply -f "$BASE/../../crossplane/terraform-provider.yaml"
kubectl wait --for=condition=Installed providers/provider-terraform
kubectl wait --for=condition=Healthy providers/provider-terraform

kubectl apply -f "$BASE/../../crossplane/terraform-provider-config.yaml"

TERRAFORM_SERVICE_ACCOUNT=$(kubectl -n crossplane-system get sa -ojson | jq -r '.items | map(.metadata.name | select(startswith("provider-terraform"))) | .[0]')

echo "Applying Terraform provider service account RBAC"
<"$BASE/terraform-provider-rbac.yaml" sed "s/{{ provider-terraform-service-account }}/$TERRAFORM_SERVICE_ACCOUNT/g" | kubectl apply -f -
