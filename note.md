Si on veut créer un agent avec DinD, il faut récupérer les certs avec 
# Récupère le cert PEM
docker cp jenkins-server:/certs/client/ca.pem ./ca.pem
docker cp jenkins-server:/certs/client/cert.pem ./cert.pem
docker cp jenkins-server:/certs/client/key.pem ./key.pem

Sinon 🏠 2. Si tu veux accéder aux certificats depuis l’hôte

Il faut utiliser un bind-mount explicite plutôt qu’un volume nommé. Par exemple :

services:
  docker:
    # …
    volumes:
      - ./certs-client:/certs/client