FROM alpine:latest

# Установите необходимые пакеты
RUN apk --no-cache add curl && \
    mkdir -p /etc/trojan

# Скачайте бинарник trojan-go напрямую (без архива)
RUN TROJAN_GO_VERSION="v1.7.0" && \
    TROJAN_GO_URL="https://github.com/p4gefau1t/trojan-go/releases/download/${TROJAN_GO_VERSION}/trojan-go-linux-amd64.tar.gz" && \
    curl -L -o /tmp/trojan-go.tar.gz ${TROJAN_GO_URL} && \
    # Распакуйте .tar.gz
    tar -xzf /tmp/trojan-go.tar.gz -C /tmp && \
    # Найдите бинарник и переместите его
    mv /tmp/trojan-go /usr/local/bin/trojan-go && \
    chmod +x /usr/local/bin/trojan-go && \
    rm -rf /tmp/*

# Скопируйте конфигурационный файл
COPY config.json /etc/trojan/config.json

# Откройте порт 443
EXPOSE 443

# Запустите сервер
CMD ["trojan-go", "-config", "/etc/trojan/config.json"]
