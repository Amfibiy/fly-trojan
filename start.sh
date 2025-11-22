#!/bin/sh
lighttpd -f /etc/lighttpd/lighttpd.conf

# Ждём, пока порт 80 станет доступен
while ! nc -z 127.0.0.1 80; do
  sleep 0.5
done

exec trojan-go -config /etc/trojan/config.json
