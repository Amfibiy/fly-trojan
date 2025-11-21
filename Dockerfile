FROM alpine:latest

# Установите необходимые пакеты
RUN apk --no-cache add curl openssl && \
    mkdir -p /etc/trojan

# Скачайте и установите trojan-go
RUN TROJAN_GO_VERSION="v0.10.6" && \
    TROJAN_GO_URL="https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip" && \
    curl -L -o /tmp/trojan-go.zip ${TROJAN_GO_URL} && \
    cd /tmp && \
    unzip trojan-go.zip && \
    mv trojan-go /usr/local/bin/trojan-go && \
    chmod +x /usr/local/bin/trojan-go && \
    rm -rf /tmp/*

# Создайте самоподписанный сертификат
RUN openssl req -newkey rsa:2048 -nodes -keyout /etc/trojan/private.key -x509 -days 365 -out /etc/trojan/cert.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=fly-trojan.onrender.com"

# Скопируйте конфигурационный файл
COPY config.json /etc/trojan/config.json

# Откройте порты 443 и 80
EXPOSE 443
EXPOSE 80

# Запустите сервер
CMD ["trojan-go", "-config", "/etc/trojan/config.json"]
