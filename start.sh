#!/bin/sh
# Запустите HTTP-сервер
lighttpd -f /etc/lighttpd/lighttpd.conf

# Дайте ему 2 секунды на запуск
sleep 2

# Запустите Trojan-Go в foreground
exec trojan-go -config /etc/trojan/config.json
