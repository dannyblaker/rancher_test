#!/bin/bash

# Edit these manually
DOMAIN="your.domain.com"
EMAIL="test@test.com"

# the rest is automatic :)

echo "1. DEFINING USEFUL VARIABLES"

# Get the directory that this script is located in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# 2. INSTALLING DOCKER AND DOCKER COMPOSE

# Stop and remove all containers
docker compose down
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Remove all volumes
docker volume rm $(docker volume ls -q)

# Remove all networks
docker network rm $(docker network ls -q)

# Remove all images
docker rmi $(docker images -q)

# Remove any existing Docker installations
sudo apt-get remove -y docker docker-engine docker.io containerd runc

# Install prerequisites
sudo apt-get update
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Download and create the GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/latest/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add the current user to the Docker group
sudo usermod -aG docker $USER



#----------------------------------------------------------
#DEPLOYING RANCHER
# Set the path to the Docker Compose file for Rancher
DOCKER_COMPOSE_RANCHER="$SCRIPT_DIR/rancher/docker-compose.yml"

# Run Docker Compose for Rancher in the specified directory
docker compose -f "$DOCKER_COMPOSE_RANCHER" up -d

#SETTING UP DIRECTUS
# Set the path to the Docker Compose file for Directus
DOCKER_COMPOSE_DIRECTUS="$SCRIPT_DIR/directus/docker-compose.yml"

# create a .env file for Directus...
DIRECTUS_ENV = "$SCRIPT_DIR/directus/.env"
# Remove read-only attribute if .env file already exists
if [ -f DIRECTUS_ENV ]; then
  chmod +w DIRECTUS_ENV
fi

DIRECTUS_PG_PASS=$(openssl rand -hex 16)
DIRECTUS_ADMIN_PASS=$(openssl rand -hex 16)
DIRECTUS_ADMIN_EMAIL="$EMAIL"
KEY=$(uuidgen)
SECRET=$(uuidgen)
PUBLIC_URL="$DOMAIN"

cat >directus/.env <<EOF
DIRECTUS_PG_PASS=$DIRECTUS_PG_PASS
DIRECTUS_ADMIN_PASS=$DIRECTUS_ADMIN_PASS
DIRECTUS_ADMIN_EMAIL=$DIRECTUS_ADMIN_EMAIL
KEY=$KEY
SECRET=$SECRET
PUBLIC_URL=$PUBLIC_URL
EOF

echo "The .env file has been created in the 'directus' directory."

if [ -f DIRECTUS_ENV ]; then
  chmod -w DIRECTUS_ENV
fi

# create a .env file for useful variables...
USEFUL_VARS_ENV = "$SCRIPT_DIR/.env"
# Remove read-only attribute if .env file already exists
if [ -f USEFUL_VARS_ENV ]; then
  chmod +w USEFUL_VARS_ENV
fi

DOMAIN="your.domain.com"
EMAIL="test@test.com"
DOCKER_COMPOSE_CYBERCHEF="$SCRIPT_DIR/cyberchef/docker-compose.yml"
DOCKER_COMPOSE_DIRECTUS="$SCRIPT_DIR/directus/docker-compose.yml"

cat >/.env <<EOF
DOMAIN=$DOMAIN
EMAIL=$EMAIL
DOCKER_COMPOSE_CYBERCHEF=$DOCKER_COMPOSE_CYBERCHEF
DOCKER_COMPOSE_DIRECTUS=$DOCKER_COMPOSE_DIRECTUS
EOF

echo "The .env file has been created in the 'directus' directory."

if [ -f USEFUL_VARS_ENV ]; then
  chmod -w USEFUL_VARS_ENV
fi


# now over to you :D

# can you make the modifications required to this
# repository to deploy the following apps to Rancher:

#   - Directus to your.domain.com/directus
#   - Cyberchef to your.domain.com/cyberchef

# kindly document your changes in the README.md file
