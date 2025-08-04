#!/bin/bash

set -euo pipefail

echo "[INFO] Provisioning Jenkins deployment..."

# Dossier jenkins synchronisé depuis l'hôte
JENKINS_DIR="$HOME/jenkins"
DEPLOY_DIR="$HOME/deploy"

# Créer le dossier de déploiement proprement
mkdir -p "$DEPLOY_DIR"

# Copier les fichiers Jenkins (si le dossier n'est pas vide)
if [ "$(ls -A "$JENKINS_DIR")" ]; then
    echo "[INFO] Copie des fichiers depuis $JENKINS_DIR vers $DEPLOY_DIR"
    cp -r "$JENKINS_DIR"/* "$DEPLOY_DIR"
else
    echo "[WARN] $JENKINS_DIR est vide, rien à copier."
fi

cd "$DEPLOY_DIR"

# Vérifier que le fichier docker-compose existe
if [ ! -f "docker-compose.yml" ] && [ ! -f "docker-compose.yaml" ]; then
    echo "[ERROR] Aucun fichier docker-compose.yml trouvé dans $DEPLOY_DIR"
    exit 1
fi

# Lancer les containers Jenkins
echo "[INFO] Construction et démarrage des containers..."
docker compose up -d --build

echo "[INFO] Jenkins démarre. Logs disponibles avec : docker compose logs -f"
