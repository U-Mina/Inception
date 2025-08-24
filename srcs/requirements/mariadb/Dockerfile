FROM debian:bullseye-slim

# RUN apt update -y && apt upgrade -y && \
# 	apt install -y mariadb-server && \
# 	apt clean && rm -rf /var/lib/apt/lists/*
	# cleaning up unnecessary package lists, reduce size of img
RUN apt-get update && apt-get install -y mariadb-server mariadb-client && \
	rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
	# 50-server.cnf: define mariaDB setting (port, usr, socket. data dir)

COPY tools/entrypoint.sh /entrypoint.sh
	# mariadb.sh: customized .sh for initing database and usrs

COPY tools/init.sh /docker-entrypoint-initdb.d/init.sh

RUN chmod +x /entrypoint.sh /docker-entrypoint-initdb.d/init.sh
# < /var/www/initial_db.sql => means: read the SQL commands
# from that file and run them on the running MySQL server (namely, init DB)

ENTRYPOINT ["/entrypoint.sh"]
# CMD ["mysqld"]
	# run this on container start