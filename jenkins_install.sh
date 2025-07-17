#!/bin/bash

set -euo pipefail

JENKINS_DIR="$HOME/jenkins"

if [ ! -d "$JENKINS_DIR" ]; then
    echo "Creating Jenkins directory at $JENKINS_DIR"
    mkdir -p "$JENKINS_DIR"
fi
cd ~
mkdir deploy
cd deploy
cp -r "$JENKINS_DIR"/* .


echo "Building and starting Jenkins containers..."
docker compose up -d --build

echo "Jenkins is starting. Check logs with: docker compose logs -f"