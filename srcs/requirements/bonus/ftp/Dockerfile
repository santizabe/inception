FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    vsftpd && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf

RUN mkdir -p /var/run/vsftpd/empty && chmod 755 /var/run/vsftpd/empty

COPY tools/script.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 21 30000-30009

CMD ["/entrypoint.sh"]
