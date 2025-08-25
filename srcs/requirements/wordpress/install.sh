#!/bin/bash

cd /var/www/html

if [ ! -f wp-cli.phar ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

if [ ! -f wp-config.php ]; then
    ./wp-cli.phar core download --allow-root
    ./wp-cli.phar config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root
    ./wp-cli.phar core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
    ./wp-cli.phar user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASS" \
        --allow-root

fi

php-fpm7.4 -F


# Function to create directories
# create_directory() {
# 	local dir_path="$1"
# 	echo "Ensuring directory exists: $dir_path"
# 	mkdir -p "$dir_path"
# 	chown -R www-data:www-data "$dir_path"
# 	chmod -R 755 "$dir_path"
# }

# # Ensure required directories exist
# create_directory "$WORDPRESS_PATH"
# create_directory "$PHP_FPM_SOCKET_PATH"


# # Switch to WordPress directory
# cd ${WORDPRESS_PATH}

# # Download and install WordPress if not installed
# if ! wp core is-installed --allow-root > /dev/null 2>&1; then
# 	echo "WordPress is not installed..."

# 	# Download WordPress
# 	wp core download --allow-root

# 	# Create wp-config.php
# 	echo "Creating wp-config.php..."
# 	wp config create \
# 		--dbname="${WORDPRESS_DB_NAME}" \
# 		--dbuser="${WORDPRESS_DB_USER}" \
# 		--dbpass="${WORDPRESS_DB_PASSWORD}" \
# 		--dbhost="${WORDPRESS_DB_HOST}" \
# 		--path="${WORDPRESS_PATH}" \
# 		--allow-root

# 	# Install WordPress with Admin user
# 	wp core install \
# 		--url="${DOMAIN_NAME}" \
# 		--title="${WORDPRESS_TITLE}" \
# 		--admin_user="${WORDPRESS_ADMIN}" \
# 		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
# 		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
# 		--skip-email \
# 		--allow-root

# 	# Create regular user
# 	wp user create \
# 		"${WORDPRESS_REGULAR_USER}" \
# 		"${WORDPRESS_REGULAR_EMAIL}" \
# 		--user_pass="${WORDPRESS_REGULAR_PASSWORD}" \
# 		--role=author \
# 		--allow-root

# 	# Install an additional theme
# 	echo "Installing additional theme: twentyfourteen..."
# 	wp theme install twentyfourteen --activate --allow-root

# else
# 	echo "WordPress is already installed..."
# fi

# # Set WordPress to listen on port 9000
# echo "Update PHP-FPM to listen on port 9000"
# sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

