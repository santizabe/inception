FROM debian:bookworm

RUN apt-get update && apt-get install nginx -y \
	&& mkdir -p /var/www/static/

COPY tools /var/www/static

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chown -R www-data /var/www && chmod -R 777 /var/www

EXPOSE 8884

CMD ["nginx", "-g", "daemon off;"]
