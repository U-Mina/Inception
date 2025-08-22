#!/bin/bash

service mariadb start;
# handle all the initialization and configuration

sleep 5;
# wait for mariadb to start

# ensures these env vars are provided for config
mysql -u "CREATE DATABASE IF NOT EXIST \'${MYSQL_DATABASE}\';"
mysql -u "CREATE USER IF NOT EXIST \'${MYSQL_USER}\'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

mysql -u "GRANT ALL PREVILEGES ON \'${MYSQL_DATABASE}\'.* TO '${MYSQL_USER}'@'%';" 
# grant user permission

mysql -u "GRANT ALL PREVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' WITH GRANT OPTION;"
# updates mariadb root password

mysql -u "FLUSH PRIVILEGES;"

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown;
# stop mariadb temporarily after init to apply change

exec mysqld_safe;
# restart mariadb in foreground for container compatibility