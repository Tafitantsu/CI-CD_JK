FROM nginx:alpine

# 1) Installer openssl
RUN apk add --no-cache openssl

# 2) Créer le dossier de certs
RUN mkdir -p /etc/nginx/certs

# 3) Générer un cert auto-signé au build
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/certs/jenkins.key \
    -out /etc/nginx/certs/jenkins.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=MonOrg/OU=Dev/CN=jenkins.local"

# 4) Copier votre conf
COPY nginx.conf /etc/nginx/nginx.conf

# (optionnel) expose ports déclarés en compose
EXPOSE 80 443
