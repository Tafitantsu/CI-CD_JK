#!/bin/bash

# -----------------------------------------
# Désinstallation des anciennes versions de Docker
# -----------------------------------------
echo "Suppression des anciens paquets Docker..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg"
done

# -----------------------------------------
# Mise à jour des paquets et installation des dépendances
# -----------------------------------------
echo "Mise à jour des paquets et installation des dépendances et git ..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl git gnupg lsb-release webhook
# Vérification de la version de l'OS
if ! grep -q "Ubuntu" /etc/os-release; then
    echo "Ce script est conçu pour Ubuntu. Veuillez l'exécuter sur une distribution Ubuntu."
    exit 1
fi

# -----------------------------------------
# Ajout de la clé GPG officielle de Docker
# -----------------------------------------
echo "Ajout de la clé GPG de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# -----------------------------------------
# Ajout du dépôt Docker au sources APT
# -----------------------------------------
echo "Ajout du dépôt Docker aux sources APT..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# -----------------------------------------
# Installation de Docker Engine
# -----------------------------------------
echo "Installation de Docker Engine..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# -----------------------------------------
# Test de l'installation
# -----------------------------------------
echo "Test de l'installation de Docker..."
sudo docker run hello-world

# -----------------------------------------
# Ajout de l'utilisateur au groupe Docker
# -----------------------------------------
echo "Ajout de l'utilisateur '$USER' au groupe Docker..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"

echo "Redémarrage du groupe pour l'utilisateur courant..."
newgrp docker

# -----------------------------------------
# Test sans sudo
# -----------------------------------------
echo "Test de Docker sans sudo..."
docker run hello-world
if [ $? -eq 0 ]; then
    echo "Docker est installé et fonctionne correctement sans sudo."
else
    echo "Erreur lors du test de Docker sans sudo."
fi