FROM debian:bullseye

# RUN apt update -y && apt upgrade -y && \
# 	apt install -y mariadb-server && \
# 	apt clean && rm -rf /var/lib/apt/lists/*
	# cleaning up unnecessary package lists, reduce size of img
RUN apt-get update && apt-get install -y mariadb-server

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d
	# 50-server.cnf: define mariaDB setting (port, usr, socket. data dir)
COPY ./tools /var/www/
	# mariadb.sh: customized .sh for initing database and usrs

RUN service mysql start && mysql < /var/www/initial_db.sql && rm -f /var/www/initial_db.sql;
# start mysql in container;
# < /var/www/initial_db.sql => means: read the SQL commands
# from that file and run them on the running MySQL server (namely, init DB)

CMD ["mysqld"]
	# run this on container start