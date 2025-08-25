#!/bin/bash

# Create mysql run directory if it doesn't exist
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# to Check if custom database exists
if [ ! -d "/var/lib/mysql/${db_name}" ]; then
    echo "Initializing database on first run..."
    
    # Create initialization SQL file with environment variables
    cat > /tmp/init.sql <<EOF
CREATE DATABASE IF NOT EXISTS \`${db_name}\`;
CREATE USER IF NOT EXISTS '${db_user}'@'%' IDENTIFIED BY '${db_pwd}';
GRANT ALL PRIVILEGES ON \`${db_name}\`.* TO '${db_user}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '12345';
FLUSH PRIVILEGES;
EOF

    echo "Starting MySQL with initialization script..."
    exec mysqld_safe --user=mysql --datadir=/var/lib/mysql --init-file=/tmp/init.sql
else
    echo "Database already initialized, starting MySQL normally..."
    exec mysqld_safe --user=mysql --datadir=/var/lib/mysql
fi