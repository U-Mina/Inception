#!/bin/bash

service mariadb start;
# handle all the initialization and configuration

sleep 5;
# wait for mariadb to start

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
# ensures these env vars are provided for config
# grant user permission
# updates mariadb root password

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown;
# stop mariadb temporarily after init to apply change

exec mysqld_safe;
# restart mariadb in foreground for container compatibility