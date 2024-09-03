#!/bin/bash

set -e

source .env

echo "Uninstalling Milvus..."
helm uninstall milvus-release -n milvus

echo "Deleting milvus namespace..."
kubectl delete namespace milvus

echo "Deleting GKE cluster..."
if [ "$CONFIG_TYPE" == "eco" ]; then
    gcloud container clusters delete $CLUSTER_NAME \
      --zone $ZONE \
      --project $PROJECT_ID \
      --quiet
else
    gcloud container clusters delete $CLUSTER_NAME \
      --region $REGION \
      --project $PROJECT_ID \
      --quiet
fi

echo "Cleanup complete!"
