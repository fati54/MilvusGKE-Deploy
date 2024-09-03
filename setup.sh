#!/bin/bash

set -e

echo "Initializing MilvusGKE-Deploy project..."

# Fonction pour demander une valeur avec une valeur par défaut
ask_with_default() {
    local prompt="$1"
    local default="$2"
    local response

    read -p "$prompt [$default]: " response
    echo ${response:-$default}
}

# Demander à l'utilisateur de choisir une configuration
echo "Choose a configuration:"
echo "1) Eco (for development and testing)"
echo "2) Standard (for small-scale production)"
echo "3) High-Performance (for intensive workloads)"
read -p "Enter your choice (1-3): " choice

case $choice in
  1)
    cp configs/eco.env .env
    echo "Eco configuration selected."
    ;;
  2)
    cp configs/standard.env .env
    echo "Standard configuration selected."
    ;;
  3)
    cp configs/high-perf.env .env
    echo "High-Performance configuration selected."
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

# Rendre les scripts exécutables
chmod +x scripts/*.sh

echo "Scripts are now executable."

# Demander les informations de configuration
PROJECT_ID=$(ask_with_default "Enter your Google Cloud Project ID" "your-project-id")
REGION=$(ask_with_default "Enter the GCP region" "us-central1")
ZONE_1=$(ask_with_default "Enter the primary zone" "$REGION-a")

if [ "$choice" != "1" ]; then
    ZONE_2=$(ask_with_default "Enter the secondary zone (leave empty for single-zone)" "")
    if [ "$choice" == "3" ]; then
        ZONE_3=$(ask_with_default "Enter the tertiary zone (leave empty if not needed)" "")
    fi
fi

NODE_COUNT=$(ask_with_default "Enter the number of nodes per zone" "1")

# Mettre à jour le fichier .env
update_env() {
    local key="$1"
    local value="$2"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|$key=.*|$key=$value|" .env
    else
        sed -i "s|$key=.*|$key=$value|" .env
    fi
}

update_env "PROJECT_ID" "$PROJECT_ID"
update_env "REGION" "$REGION"
update_env "ZONE" "$ZONE_1"
update_env "NODE_COUNT" "$NODE_COUNT"

if [ "$choice" != "1" ]; then
    update_env "ZONE_1" "$ZONE_1"
    [ -n "$ZONE_2" ] && update_env "ZONE_2" "$ZONE_2"
    [ "$choice" == "3" ] && [ -n "$ZONE_3" ] && update_env "ZONE_3" "$ZONE_3"
fi

echo "Configuration updated in .env file."

echo "Setup complete. You can now run './scripts/create_cluster.sh' to start deploying Milvus on GKE."
