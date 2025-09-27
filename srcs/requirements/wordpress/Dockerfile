FROM debian:bookworm

RUN apt-get update

RUN apt-get upgrade

RUN apt-get install -y php8.2-cli php8.2-fpm php8.2-mysql php8.2-xml php8.2-curl php8.2-zip curl wget openssl

RUN mkdir -p /run/php/

RUN sed -i "s|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|g" /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /var/www

WORKDIR /var/www

RUN mkdir -p /var/www/wp-content/uploads

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY conf/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["/usr/local/bin/script.sh"]

EXPOSE 9000
