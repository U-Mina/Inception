#!/bin/bash

set -e

# if [ ! -f /etc/ssl/certs/nginx.crt ]; then
# echo "Nginx: setting up ssl ...";
# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt -subj "/C=DE/ST=BW/L=HN/O=42HN/CN=ewu.42.fr";
# echo "Nginx: ssl is set up!";
# fi

# exec "$@"

# Set environment variables
SSL_DIR="/etc/nginx/ssl"
CONF_DIR="/etc/nginx/sites-available"
CONF_FILE="${CONF_DIR}/custom-site"

# Ensure SSL directory exists
mkdir -p ${SSL_DIR}

# Generate SSL certificates if they don't exist
if [ ! -f "${SSL_DIR}/certificate.crt" ] || [ ! -f "${SSL_DIR}/private.key" ]; then
	echo "Generating SSL certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout "${SSL_DIR}/private.key" \
		-out "${SSL_DIR}/certificate.crt" \
		-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"
else
	echo "SSL certificates already exist. Skipping generation."
fi

# Generate NGINX configuration file
if [ ! -f "${CONF_FILE}" ]; then
	echo "Configuring NGINX..."

	# Replace ${DOMAIN_NAME} in the NGINX configuration template
	envsubst '${DOMAIN_NAME}' < "${CONF_FILE}.template" > "${CONF_FILE}"
	rm -rf "${CONF_FILE}.template"

	# Create symbolic link for the configuration file
	ln -sf "${CONF_FILE}" /etc/nginx/sites-enabled/
fi

# Start NGINX in the foreground
echo "Starting NGINX..."
exec nginx -g "daemon off;"