FROM alpine:latest

# Установите зависимости
RUN apk --no-cache add curl openssl lighttpd && \
    mkdir -p /etc/trojan

# Скачайте Trojan-Go
RUN TROJAN_GO_VERSION="v0.10.6" && \
    TROJAN_GO_URL="https://github.com/p4gefau1t/trojan-go/releases/download/${TROJAN_GO_VERSION}/trojan-go-linux-amd64.zip" && \
    curl -L -o /tmp/trojan-go.zip ${TROJAN_GO_URL} && \
    cd /tmp && \
    unzip trojan-go.zip && \
    mv trojan-go /usr/local/bin/trojan-go && \
    chmod +x /usr/local/bin/trojan-go && \
    rm -rf /tmp/*

# Создайте самоподписанный сертификат
RUN openssl req -newkey rsa:2048 -nodes -keyout /etc/trojan/private.key -x509 -days 365 -out /etc/trojan/cert.crt -subj "/CN=fly-trojan.onrender.com"

# Настройте lighttpd (HTTP-сервер для health-check)
RUN echo 'server.document-root = "/var/www"' > /etc/lighttpd/lighttpd.conf && \
    echo 'server.port = 80' >> /etc/lighttpd/lighttpd.conf && \
    mkdir -p /var/www && \
    echo "OK" > /var/www/index.html

# Скопируйте конфиг
COPY config.json /etc/trojan/config.json

# Откройте порты
EXPOSE 80
EXPOSE 443

# Запустите оба сервиса
CMD sh -c "lighttpd -f /etc/lighttpd/lighttpd.conf & trojan-go -config /etc/trojan/config.json"
