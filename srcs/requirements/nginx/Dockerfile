FROM debian:bullseye-slim

# RUN apt update -y && apt upgrade -y && \
# 	apt install -y nginx openssl && \
# 	apt clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y nginx openssl gettext-base && \
	rm -rf /var/lib/apt/lists/*
	
COPY conf/custom-site.template /etc/nginx/sites-enabled/custom-site.template
	# the nginx.conf is copied TO container at '/etc/nginx/nginx.conf'

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# CMD ["nginx", "-g", "daemon off;"]
	# run nginx in the foreground(daemon off), ensuring container stays alive

	# web server for wp

	# the following is removed to entrypoint.sh!
# RUN mkdir -p /etc/nginx/ssl && \
# 	# mkdir -p /etc/nginx/ssl: create dir to store SSL files
# 	openssl req -x509 -nodes -days 365 \
# 	# openssl req: init certificate creation
# 	# -x509: create X.509 certificate;
# 	# -node: no PW required for private key
# 	# -days 365: certificate valid for 1 year
# 	-keyout /etc/nginx/ssl/inception.key \
# 	# private key is written to this loc
# 	-out /etc/nginx/ssl/inception.crt \
# 	# certificate file is written to this loc
# 	-subj "/CN=${DOMAIN_NAME}"
# 	# specifice subject of certificate in single line
# 	# /CN= Common Name, usually domain name for SSL (example.com)
# 	# ${DOMAIN_NAME}: env var

# RUN mkdir -p /var/www/wordpress /var/run/nginx && \
# 	# /var/www/wordpress: dir for wp
# 	chmod 755 /var/www/wordpress && \
# 	chown -R www-data:www-data /var/www/wordpress
# 	# set ownership and permission for www-data usr