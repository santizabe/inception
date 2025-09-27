FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl curl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN openssl req -subj "/C=SP/ST=Malaga/L=Malaga/O=42 Malaga/OU=szapata-/CN=szapata-" \
	-new -newkey rsa:2048 -days 365 -nodes -x509 \
	-keyout /etc/ssl/private/szapata-.42.fr.key \
	-out /etc/ssl/certs/szapata-.42.fr.crt

RUN chown -R www-data /var/www && chmod -R 777 /var/www

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
