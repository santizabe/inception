#!/bin/bash

if [ "$ENABLE_BONUS" = "true" ]; then
	cp /etc/nginx/nginx.d/bonus.conf /etc/nginx/nginx.conf
else
	cp /etc/nginx/nginx.d/nginx.conf /etc/nginx/nginx.conf
fi

exec nginx -g "daemon off;"
