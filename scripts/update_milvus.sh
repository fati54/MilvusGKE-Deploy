#!/bin/bash

set -e

source .env

echo "Updating Milvus Helm repository..."
helm repo update

echo "Upgrading Milvus with $CONFIG_TYPE configuration..."
helm upgrade milvus-release milvus/milvus \
  --version $MILVUS_VERSION \
  -f milvus-values/$CONFIG_TYPE-values.yaml \
  --namespace milvus

echo "Waiting for Milvus pods to be ready..."
kubectl wait --for=condition=ready pod --all -n milvus --timeout=600s

echo "Milvus upgrade complete! Pods:"
kubectl get pods -n milvus

echo "Services:"
kubectl get services -n milvus
