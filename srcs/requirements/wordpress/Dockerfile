FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y php-mysql php-fpm curl \
	default-mysql-client netcat && \
	rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# cpy conf into ocntainer
# COPY ./conf/entrypoint.sh /etc/php/7.3/fpm/pool.d

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT [ "/entrypoint.sh" ]

# RUN apt update -y && apt upgrade -y && \
# 	apt install -y curl php7.4 php-fpm php-mysql mariadb-client && \
# 	apt clean && rm -rf /var/lib/apt/lists/*
	# php7.4: main php runtime
	# php-fpm: fastCGI process for PHP
	# php-mysql: php extension to interact with mysql
	# mariadb-client: allow container to interact with mariadb server