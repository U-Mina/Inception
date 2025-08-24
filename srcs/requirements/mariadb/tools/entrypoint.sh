#!/bin/bash
# -- service mariadb start;
# handle configuration

set -e

mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -f "/var/lib/mysql/initialized" ]; then
	/docker-entrypoint-initdb.d/init.sh
	touch /var/lib/mysql/initialized
fi

exec mysqld --user=mysql
# -- sleep 5;
# wait for mariadb to start

# -- mysql -u root << EOF
# CREATE DATABASE IF NOT EXISTS wordpress;
# CREATE USER IF NOT EXISTS 'ewu'@'%' IDENTIFIED BY '123';
# -- CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON wordpress.* TO 'ewu'@'%';
# -- GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
# FLUSH PRIVILEGES;

# ALTER USER 'root'@'localhost' IDENTIFIED BY '123';
# -- EOF

# -- # ensures these env vars are provided for config
# -- # grant user permission
# -- # updates mariadb root password

# -- mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown;
# -- # stop mariadb temporarily after init to apply change

# -- exec mysqld_safe;
# -- # restart mariadb in foreground for container compatibility