FROM alpine:latest

# Установите необходимые пакеты
RUN apk --no-cache add curl unzip && \
    mkdir -p /etc/trojan

# Скачайте и распакуйте trojan-go
RUN TROJAN_GO_VERSION="v1.7.0" && \
    TROJAN_GO_URL="https://github.com/p4gefau1t/trojan-go/releases/download/${TROJAN_GO_VERSION}/trojan-go-linux-amd64.zip" && \
    curl -L ${TROJAN_GO_URL} -o /tmp/trojan-go.zip && \
    cd /tmp && \
    unzip trojan-go.zip && \
    # Проверьте, что бинарник существует, и переместите его
    mv trojan-go* /usr/local/bin/trojan-go && \
    rm -rf /tmp/*

# Скопируйте конфигурационный файл
COPY config.json /etc/trojan/config.json

# Откройте порт 443
EXPOSE 443

# Запустите сервер
CMD ["trojan-go", "-config", "/etc/trojan/config.json"]
