#!/bin/bash

# Set WordPress credentials
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/db_password)
WORDPRESS_REGULAR_PASSWORD=$(cat /run/secrets/wp_password)
WORDPRESS_PATH="/var/www/html/wordpress"
PHP_FPM_SOCKET_PATH="/run/php"

# Function to create directories
create_directory() {
	local dir_path="$1"
	echo "Ensuring directory exists: $dir_path"
	mkdir -p "$dir_path"
	chown -R www-data:www-data "$dir_path"
	chmod -R 755 "$dir_path"
}

# Ensure required directories exist
create_directory "$WORDPRESS_PATH"
create_directory "$PHP_FPM_SOCKET_PATH"


# Switch to WordPress directory
cd ${WORDPRESS_PATH}

# Download and install WordPress if not installed
if ! wp core is-installed --allow-root > /dev/null 2>&1; then
	echo "WordPress is not installed..."

	# Download WordPress
	wp core download --allow-root

	# Create wp-config.php
	echo "Creating wp-config.php..."
	wp config create \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--path="${WORDPRESS_PATH}" \
		--allow-root

	# Install WordPress with Admin user
	wp core install \
		--url="${DOMAIN_NAME}" \
		--title="${WORDPRESS_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--skip-email \
		--allow-root

	# Create regular user
	wp user create \
		"${WORDPRESS_REGULAR_USER}" \
		"${WORDPRESS_REGULAR_EMAIL}" \
		--user_pass="${WORDPRESS_REGULAR_PASSWORD}" \
		--role=author \
		--allow-root

	# Install an additional theme
	echo "Installing additional theme: twentyfourteen..."
	wp theme install twentyfourteen --activate --allow-root

else
	echo "WordPress is already installed..."
fi

# Set WordPress to listen on port 9000
echo "Update PHP-FPM to listen on port 9000"
sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Check if WordPress settings are correct
echo "Validating PHP-FPM configuration..."
php-fpm7.4 -t

# Start WordPress
echo "Starting PHP-FPM..."
php-fpm7.4 -F


# # automate the process of setting up WP ENV with: 
# # - mk install dir; 
# # - config WP with env vars
# # - install WP with admin usr
# # - create another usr (editor)
# # -start php-fpm service to serve WP

# sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf";
# chown -R www-data:www-data /var/www/*;
# chown -R 755 /var/www/*;
# mkdir -p /run/php/;
# touch /run/php/php7.3-fpm.pid;

# if [ ! -f /var/www/html/wp-config.php ]; then
# 	echo "Wordpress: Setting up..."
# 	mkdir -p /var/www/html
# 	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
# 	chmod +x wp-cli.phar; 
# 	mv wp-cli.phar /usr/local/bin/wp;
# 	cd /var/www/html;
# 	wp core download --allow-root;
# 	mv /var/www/wp-config.php /var/www/html/
# 	echo "Wordpress: Creating users..."
# 	wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
# 	wp user create --allow-root ${WP_USER_LOGIN} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD};
# 	echo "Wordpress: Finished!"
# fi

# exec "$@"


# 	# create another usr 'editor' using provided env vars
# 	wp user create \
# 		"${WP_USER}" "${WP_USER_EMAIL}" \
# 		--user_pass="${WP_USER_PASSWORD}" \
# 		--role=editor \
# 		--allow-root
# fi

# if ! wp theme is-installed twentytwentyfour --allow-root; then
# 	wp theme install twentytwentyfour --activate --allow-root
# else
# 	wp theme activate twentytwentyfour --allow-root;
# fi

# mkdir -p /run/php
# # create runtime dir
# echo "Starting PHP-FPM..."
# php-fpm7.4 -F
# # start pgp-fpm in foreground
