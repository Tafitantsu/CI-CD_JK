#!/bin/bash

set -euo pipefail

JENKINS_DIR="$HOME/jenkins"

if [ ! -d "$JENKINS_DIR" ]; then
    echo "Creating Jenkins directory at $JENKINS_DIR"
    mkdir -p "$JENKINS_DIR"
fi

cd "$JENKINS_DIR"

echo "Pulling latest Docker images..."
docker compose pull

echo "Building and starting Jenkins containers..."
docker compose up -d --build

echo "Jenkins is starting. Check logs with: docker compose logs -f"