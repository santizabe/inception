FROM debian:bookworm

ARG DB_NAME
ARG DB_USER
ARG DB_PASS

RUN apt-get update && apt-get install -y \
	mariadb-server mariadb-client

RUN	mkdir -p /var/run/mysqld

RUN chmod 777 /var/run/mysqld

RUN	chown -R mysql:mysql /var/lib/mysql

RUN echo '[mysqld]\nskip-host-cache\nskip-name-resolve\nbind-address=0.0.0.0' > /etc/mysql/conf.d/my.cnf

RUN sed -i 's/^skip-networking/#skip-networking/' /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mysql_install_db --user=mysql

EXPOSE 3306

COPY conf/db.sh /usr/local/bin/config_db.sh

RUN chmod +x /usr/local/bin/config_db.sh

CMD ["/usr/local/bin/config_db.sh"]

HEALTHCHECK --interval=10s \
	CMD mysqladmin ping -h mariadb -P 3306 --silent || exit 1
