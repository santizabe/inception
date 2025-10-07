#!/bin/bash

if ! id -u ${FTP_USER} >/dev/null 2>&1; then
	useradd -m "${FTP_USER}"
fi

echo "${FTP_USER}:${FTP_PASS}" | chpasswd

exec /usr/sbin/vsftpd /etc/vsftpd.conf

