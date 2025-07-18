# Projet Jenkins avec Docker

Ce projet fournit une configuration pour exécuter Jenkins dans un conteneur Docker. Il comprend un environnement Jenkins personnalisé, un proxy inverse Nginx et une configuration Docker Compose pour une orchestration facile.

## Installation

1.  **Installez Docker et Docker Compose.** Assurez-vous que Docker et Docker Compose sont installés sur votre système.
2.  **Clonez le référentiel.** Clonez ce référentiel sur votre machine locale.
3.  **Exécutez Docker Compose.** Exécutez la commande suivante pour créer et démarrer les conteneurs :

    ```bash
    docker-compose up -d
    ```

## Usage

Une fois les conteneurs en cours d'exécution, vous pouvez accéder à Jenkins à l'adresse [http://localhost:8080](http://localhost:8080). Le proxy inverse Nginx transmettra les requêtes au conteneur Jenkins.
