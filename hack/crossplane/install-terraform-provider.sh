#!/bin/bash
set -eo pipefail

BASE="$(readlink -f "$(dirname $0)")"
PROVIDER="$BASE/../../crossplane/provider"

while ! kubectl api-resources | grep pkg.crossplane.io; do sleep 1; done

kubectl apply -f "$PROVIDER/terraform-provider.yaml"
kubectl wait --for=condition=Installed providers/provider-terraform
kubectl wait --for=condition=Healthy providers/provider-terraform

kubectl apply -f "$PROVIDER/terraform-provider-config.yaml"

TERRAFORM_SERVICE_ACCOUNT=$(kubectl -n crossplane-system get sa -ojson | jq -r '.items | map(.metadata.name | select(startswith("provider-terraform"))) | .[0]')

echo "Applying Terraform provider service account RBAC"
<"$BASE/terraform-provider-rbac.yaml" sed "s/{{ provider-terraform-service-account }}/$TERRAFORM_SERVICE_ACCOUNT/g" | kubectl apply -f -
