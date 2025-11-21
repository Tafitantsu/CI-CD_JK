#!/bin/bash

# --- Configuration et Vérification ---
DOCKER_PKGS="docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc"
REQUIRED_DEPS="ca-certificates curl git gnupg lsb-release webhook"
OS_NAME="Ubuntu"

## -----------------------------------------
## Fonction de test du statut du groupe Docker
## -----------------------------------------
# Fonction qui s'exécute dans le nouveau shell 'newgrp'
check_docker_permissions() {
    echo ""
    echo "--- 🐳 VÉRIFICATION DES PERMISSIONS DOCKER ---"
    
    # Exécute la commande de test
    docker run hello-world &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Docker est installé et fonctionne correctement SANS sudo pour l'utilisateur '$USER'."
        echo "💡 Vous pouvez maintenant quitter ce shell (tapez 'exit' ou Ctrl+D)."
    else
        echo "❌ Échec de l'exécution du test Docker sans sudo."
        echo "👉 **Action Requise: Veuillez vous déconnecter et vous reconnecter** pour que la nouvelle appartenance au groupe 'docker' prenne effet."
        echo "   Si l'erreur persiste après la reconnexion, veuillez vérifier le statut de votre service Docker."
    fi
}

## -----------------------------------------
## Désinstallation des anciennes versions de Docker
## -----------------------------------------
echo "🚀 Démarrage de l'installation de Docker..."
echo "Suppression des anciens paquets Docker..."
for pkg in $DOCKER_PKGS; do
    sudo apt-get remove -y "$pkg" 2>/dev/null || true
done

## -----------------------------------------
## Mise à jour des paquets et installation des dépendances
## -----------------------------------------
echo "Mise à jour des paquets et installation des dépendances..."
sudo apt-get update
sudo apt-get install -y $REQUIRED_DEPS

# Vérification de la version de l'OS
if ! grep -q "$OS_NAME" /etc/os-release; then
    echo "🚨 Ce script est conçu pour $OS_NAME. Veuillez l'exécuter sur une distribution $OS_NAME."
    exit 1
fi

## -----------------------------------------
## Installation de Docker
## -----------------------------------------
echo "Installation des dépôts et de Docker Engine..."
# Ajout de la clé GPG officielle de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Ajout du dépôt Docker au sources APT
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation de Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

## -----------------------------------------
## Test initial (avec sudo pour garantir le fonctionnement)
## -----------------------------------------
echo "Test initial de l'installation de Docker (avec sudo)..."
if sudo docker run hello-world; then
    echo "✅ Test initial réussi. Docker Engine est fonctionnel."
else
    echo "❌ Échec du test initial de Docker. Veuillez vérifier l'installation."
    exit 1
fi

## -----------------------------------------
## Ajout de l'utilisateur au groupe Docker
## -----------------------------------------
echo ""
echo "--- 🧑‍💻 CONFIGURATION UTILISATEUR ---"

# Vérification si l'utilisateur est déjà dans le groupe
if groups "$USER" | grep -q "docker"; then
    echo "L'utilisateur '$USER' est déjà membre du groupe 'docker'. Aucune modification nécessaire."
else
    echo "Ajout de l'utilisateur '$USER' au groupe 'docker'..."
    # Crée le groupe s'il n'existe pas (2>/dev/null || true pour éviter l'erreur si le groupe existe)
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker "$USER"
    echo "🔔 **ATTENTION: L'appartenance au groupe a été modifiée.**"
    echo "   Pour que le test sans sudo fonctionne, nous allons lancer une nouvelle session temporaire."
fi

## -----------------------------------------
## Test sans sudo (méthode newgrp)
## -----------------------------------------
# Utilisation de 'exec newgrp docker' pour remplacer le shell courant,
# mais pour ne pas arrêter l'exécution si l'utilisateur quitte newgrp,
# on utilise 'newgrp' seul avec une fonction.

echo "Lancement d'une nouvelle session temporaire pour tester les permissions sans sudo..."
# Lance un nouveau shell avec le nouveau groupe effectif, puis appelle la fonction de vérification
newgrp docker /bin/bash -c "$(declare -f check_docker_permissions); check_docker_permissions"

# Le script principal reprend ici.
echo "-----------------------------------------"
echo "Installation et configuration terminées."