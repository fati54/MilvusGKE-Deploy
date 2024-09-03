#!/bin/bash

set -e

source .env

echo "Adding Milvus Helm repository..."
helm repo add milvus https://milvus-io.github.io/milvus-helm/
helm repo update

echo "Deploying Milvus with $CONFIG_TYPE configuration..."
helm install milvus-release milvus/milvus \
  --version $MILVUS_VERSION \
  -f milvus-values/$CONFIG_TYPE-values.yaml \
  --create-namespace \
  --namespace milvus

echo "Waiting for Milvus pods to be ready..."
kubectl wait --for=condition=ready pod --all -n milvus --timeout=600s

echo "Milvus deployment complete! Pods:"
kubectl get pods -n milvus

echo "Services:"
kubectl get services -n milvus
