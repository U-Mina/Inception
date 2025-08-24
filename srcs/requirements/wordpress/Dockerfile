FROM debian:bullseye

RUN apt-get update && apt-get install -y php7.3 php-mysqli php-fpm wget sendmail
# RUN apt update -y && apt upgrade -y && \
# 	apt install -y curl php7.4 php-fpm php-mysql mariadb-client && \
# 	apt clean && rm -rf /var/lib/apt/lists/*
	# php7.4: main php runtime
	# php-fpm: fastCGI process for PHP
	# php-mysql: php extension to interact with mysql
	# mariadb-client: allow container to interact with mariadb server

	EXPOSE 9000

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d
	# cpy conf into ocntainer

COPY ./tools /var/www/

RUN chmod +x /var/www/wordpress_start.sh

ENTRYPOINT [ "/var/www/wordpress_start.sh" ]

CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]