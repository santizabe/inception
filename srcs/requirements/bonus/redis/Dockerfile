FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	lsb-release curl gpg && \
	curl -fsSL https://packages.redis.io/gpg | \
	gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg && \
	chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg && \
	echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | \
	tee /etc/apt/sources.list.d/redis.list && apt-get update && \
	apt-get install -y redis

COPY conf/redis.conf /etc/redis/redis.conf

RUN mkdir -p /var/lib/redis && \
	chown redis:redis /var/lib/redis

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
