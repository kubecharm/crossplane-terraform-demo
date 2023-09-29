# About

This repository is part of the blog [post](https://kubecharm.com/blog/how-to-use-crossplane-with-terraform/) published on the Kubecharm blog. Please follow it for a detailed walkthrough.

# Setup

### Prerequisites

To run the samples, in addition to Docker (or another container runtime) you'll need to have the following tools installed:

* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [helm](https://helm.sh/)
* [kind](https://kind.sigs.k8s.io/)

### Getting started

1. Create the demo kind cluster with Crossplane installed by running:

```
./hack/cluster-up.sh
```

2. Export the kubeconfig so that you can use `kubectl` to interact with the cluster:

```
export KUBECONFIG="$PWD/kubeconfig.yaml"
```
