#!/bin/bash

# automate the process of setting up WP ENV with: 
# - mk install dir; 
# - config WP with env vars
# - install WP with admin usr
# - create another usr (editor)
# -start php-fpm service to serve WP

	sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf";
	chown -R www-data:www-data /var/www/*;
	chown -R 755 /var/www/*;
	mkdir -p /run/php/;
	touch /run/php/php7.3-fpm.pid;

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Wordpress: Setting up..."
	mkdir -p /var/www/html
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
	chmod +x wp-cli.phar; 
	mv wp-cli.phar /usr/local/bin/wp;
	cd /var/www/html;
	wp core download --allow-root;
	mv /var/www/wp-config.php /var/www/html/
	echo "Wordpress: Creating users..."
	wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
	wp user create --allow-root ${WP_USER_LOGIN} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD};
	echo "Wordpress: Finished!"
fi

exec "$@"

# mkdir -p /var/www/wordpress
# cd /var/www/wordpress
# # create dir for wp

# if [ ! -f /usr/local/bin/wp ]; then
# 	curl -0 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# 	chmod +x wp-cli.phar
# 	mv wp-cli.phar /usr/local/bin/wp
# fi
# # download and install wp-cli

# if [ ! -f wp-config.php ]; then
# 	wp core download --allow-root
# 	# download wp-core into /var/www/wordpress

# 	mv wp-config-sample.php wp-config.php
# 	# move sample config file, rename to wp-cofig.php

# 	# config database connection
# 	sed -i "s|database_name_here|${MYSQL_DATABASE}|" wp-config.php
# 	sed -i "s|username_here|${MYSQL_USER}|" wp-config.php
# 	sed -i "s|password_here|${MYSQL_PASSWORD}|" wp-config.php
# 	# use databse 'name', 'user', 'pw' from evn vars
# 	sed -i "s|localhost|mariadb|" wp-config.php
# 	# replace localhost with mariadb (here assuming container name [mariadb]!)
# fi

# echo "Waiting for database connection..."
# sleep 8

# if ! wp core is-installed --allow-root; then
# 	if [[ "${WP_ADMIN_USER}" =~ [Aa]dmin|[Aa]dministrator ]]; then
#         echo "Error: Administrator username cannot contain 'admin', 'Admin', or 'administrator' ..."
#         exit 1
#     fi

# 	# install wp
# 	wp core install \
# 		--url="${DOMAIN_NAME}" \
# 		--title="${SITE_TITLE}" \
# 		--admin_user="${WP_ADMIN_USER}" \
# 		--admin_password="${WP_ADMIN_PASSWORD}" \
# 		--admin_email="${WP_ADMIN_EMAIL}" \
# 		--skip-emal \
# 		--allow-root
# 		# domain name for wp site
# 		# site title (eg "inception")
# 		# user, ps, email => set up admin account with provided credentials

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
