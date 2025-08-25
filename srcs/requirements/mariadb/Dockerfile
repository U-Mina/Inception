FROM debian:bullseye

# RUN apt update -y && apt upgrade -y && \
# 	apt install -y mariadb-server && \
# 	apt clean && rm -rf /var/lib/apt/lists/*
	# cleaning up unnecessary package lists, reduce size of img
RUN apt-get update && apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

RUN sed -i 's/bind-address.*= 127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Change bind-address from 127.0.0.1 to 0.0.0.0 to allow network connections
# COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# 	# 50-server.cnf: define mariaDB setting (port, usr, socket. data dir)
# Initialize MySQL data directory and set proper ownership

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN chown -R mysql:mysql /var/lib/mysql

COPY ./start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]
# COPY tools/entrypoint.sh /entrypoint.sh
# 	# mariadb.sh: customized .sh for initing database and usrs

# COPY tools/init.sh /docker-entrypoint-initdb.d/init.sh

# RUN chmod +x /entrypoint.sh /docker-entrypoint-initdb.d/init.sh
# # < /var/www/initial_db.sql => means: read the SQL commands
# # from that file and run them on the running MySQL server (namely, init DB)

# ENTRYPOINT ["/entrypoint.sh"]
	# run this on container start