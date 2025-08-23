FROM debian:bullseye

RUN apt update -y && apt upgrade -y && \
	apt install -y mariadb-server && \
	apt clean && rm -rf /var/lib/apt/lists/*
	# cleaning up unnecessary package lists, reduce size of img

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
	# 50-server.cnf: define mariaDB setting (port, usr, socket. data dir)
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
	# mariadb.sh: customized .sh for initing database and usrs

RUN chmod +x /usr/local/bin/mariadb.sh
	# set permisson +x (exec)

CMD ["/usr/local/bin/mariadb.sh"]
	# run this .sh on container start

# cmd for build and run container
# docker build -t mariadb-img .
# docker run -d --name mariadb-container -p 3306:3306 \
#   -e MYSQL_DATABASE=mydb \
#   -e MYSQL_USER=myuser \
#   -e MYSQL_PASSWORD=mypass \
#   -e MYSQL_ROOT_PASSWORD=myrootpass mariadb-img
# FROM debian:buster

# RUN apt-get update -y && apt-get install mariadb-server -y

# COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# COPY ./tools/script.sh /

# CMD ["/script.sh"]