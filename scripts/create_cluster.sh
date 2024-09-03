#!/bin/bash

set -e

source .env

echo "Creating GKE cluster with $CONFIG_TYPE configuration..."

if [ "$CONFIG_TYPE" == "eco" ]; then
    gcloud container clusters create $CLUSTER_NAME \
      --zone $ZONE \
      --project $PROJECT_ID \
      --num-nodes $NODE_COUNT \
      --machine-type $MACHINE_TYPE \
      --disk-type $DISK_TYPE \
      --disk-size $DISK_SIZE \
      --enable-ip-alias \
      --enable-autoscaling \
      --min-nodes $MIN_NODES \
      --max-nodes $MAX_NODES \
      --enable-autorepair \
      --enable-autoupgrade
elif [ "$CONFIG_TYPE" == "standard" ]; then
    gcloud container clusters create $CLUSTER_NAME \
      --region $REGION \
      --node-locations $ZONE_1,$ZONE_2 \
      --project $PROJECT_ID \
      --num-nodes $NODE_COUNT \
      --machine-type $MACHINE_TYPE \
      --disk-type $DISK_TYPE \
      --disk-size $DISK_SIZE \
      --enable-ip-alias \
      --enable-autoscaling \
      --min-nodes $MIN_NODES \
      --max-nodes $MAX_NODES \
      --enable-autorepair \
      --enable-autoupgrade
else
    gcloud container clusters create $CLUSTER_NAME \
      --region $REGION \
      --node-locations $ZONE_1,$ZONE_2,$ZONE_3 \
      --project $PROJECT_ID \
      --num-nodes $NODE_COUNT \
      --machine-type $MACHINE_TYPE \
      --disk-type $DISK_TYPE \
      --disk-size $DISK_SIZE \
      --enable-ip-alias \
      --enable-network-policy \
      --enable-autoscaling \
      --min-nodes $MIN_NODES \
      --max-nodes $MAX_NODES \
      --enable-autorepair \
      --enable-autoupgrade \
      --enable-vertical-pod-autoscaling
fi

echo "Configuring kubectl..."
if [ "$CONFIG_TYPE" == "eco" ]; then
    gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID
else
    gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID
fi

echo "Cluster created successfully. Nodes:"
kubectl get nodes

echo "Cluster creation complete!"
