#!/bin/sh

set -e

if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then

	cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASS}';

CREATE DATABASE IF NOT EXISTS ${DB_NAME};
ALTER DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	mysqld --user=mysql --bootstrap < /tmp/create_db.sql
	chown -R www-data /var/lib/mysql
	chmod -R 777 /var/lib/mysql
	if [ $? -ne 0 ]; then
		echo "Error: Failed to create database and user.";
		exit 1
	fi
	echo "Database and user created successfully"
fi

chown -R www-data /var/lib/mysql
chmod -R 777 /var/lib/mysql

exec mysqld_safe --user=mysql --bind-address=0.0.0.0