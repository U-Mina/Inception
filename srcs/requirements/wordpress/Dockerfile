FROM debian:bullseye

RUN apt-get update && apt-get install -y php \
	php-mysql php-fpm curl
	# rm -rf /var/lib/apt/lists/*

# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
RUN mkdir /run/php
RUN mkdir -p /var/www/html
RUN sed -i 's|^listen = .*|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# cpy conf into ocntainer
# COPY ./conf/entrypoint.sh /etc/php/7.3/fpm/pool.d

COPY ./install.sh .

RUN chmod +x install.sh

CMD [ "./install.sh" ]
# WORKDIR /var/www/html

# ENTRYPOINT [ "/entrypoint.sh" ]

# RUN apt update -y && apt upgrade -y && \
# 	apt install -y curl php7.4 php-fpm php-mysql mariadb-client && \
# 	apt clean && rm -rf /var/lib/apt/lists/*
	# php7.4: main php runtime
	# php-fpm: fastCGI process for PHP
	# php-mysql: php extension to interact with mysql
	# mariadb-client: allow container to interact with mariadb server