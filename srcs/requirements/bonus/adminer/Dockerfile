FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php8.2 php8.2-cli php8.2-mysql\
	php8.2-mbstring wget unzip

WORKDIR /var/www

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www"]
