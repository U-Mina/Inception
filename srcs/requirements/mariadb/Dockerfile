# FROM debian:bullseye

# # RUN apt update -y && apt upgrade -y && \
# # 	apt install -y mariadb-server && \
# # 	apt clean && rm -rf /var/lib/apt/lists/*
# 	# cleaning up unnecessary package lists, reduce size of img
# RUN apt-get update && apt-get install -y mariadb-server

# EXPOSE 3306

# COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d
# 	# 50-server.cnf: define mariaDB setting (port, usr, socket. data dir)
# COPY ./tools /var/www/
# 	# mariadb.sh: customized .sh for initing database and usrs

# RUN service mysql start && mysql < /var/www/initial_db.sql && rm -f /var/www/initial_db.sql;
# # start mysql in container;
# # < /var/www/initial_db.sql => means: read the SQL commands
# # from that file and run them on the running MySQL server (namely, init DB)

# CMD ["mysqld"]
# 	# run this on container start
FROM mariadb:10.6

# Expose default MariaDB port
EXPOSE 3306

# Copy custom MariaDB configuration
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization SQL scripts
# Any .sql or .sh in /docker-entrypoint-initdb.d/ will be executed
# automatically when the container first starts
COPY ./tools/initial_db.sql /docker-entrypoint-initdb.d/
# If you have additional init scripts (e.g., mariadb.sh), copy them as well:
# COPY ./tools/mariadb.sh /docker-entrypoint-initdb.d/

# Set ownership (optional, ensures proper permissions)
RUN chown -R mysql:mysql /docker-entrypoint-initdb.d

# No need to run 'service mysql start' or 'mysql < ...' here!
# The official MariaDB image will initialize the DB at container startup.

# Default command runs MariaDB server
CMD ["mysqld"]
