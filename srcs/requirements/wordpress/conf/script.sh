#!/bin/bash

if [ ! -f "/var/www/wp-config.php" ]; then
    wp core download --allow-root --path='/var/www'
    wp config create --allow-root \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASS \
        --dbhost=mariadb:3306 --path='/var/www'
    
    wp core install --allow-root \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL --path='/var/www'

    wp user create --allow-root \
        $WP_USER $WP_USER_EMAIL \
        --role=author --user_pass=$WP_USER_PASSWORD --path='/var/www'
fi

if [ "$ENABLE_REDIS" = "true" ]; then
    wp config set WP_CACHE true --raw --allow-root --path='/var/www'
    wp config set WP_REDIS_HOST redis --allow-root --path='/var/www'
    wp config set WP_REDIS_PORT 6379 --raw --allow-root --path='/var/www'

    if ! wp plugin is-installed redis-cache --allow-root --path='/var/www'; then
        wp plugin install redis-cache --activate --allow-root --path='/var/www'
    fi

    wp redis enable --allow-root --path='/var/www'
fi
chown -R www-data /var/www
chmod -R 777 /var/www

exec /usr/sbin/php-fpm8.2 -F