FROM alpine:latest

# Установите необходимые пакеты
RUN apk --no-cache add curl unzip && \
    mkdir -p /etc/trojan

# Скачайте и распакуйте trojan-go
RUN TROJAN_GO_VERSION="v1.7.0" && \
    TROJAN_GO_URL="https://github.com/p4gefau1t/trojan-go/releases/download/${TROJAN_GO_VERSION}/trojan-go-linux-amd64.zip" && \
    curl -L -o /tmp/trojan-go.zip ${TROJAN_GO_URL} && \
    # Проверьте, что архив скачался
    unzip -t /tmp/trojan-go.zip && \
    # Распакуйте архив
    cd /tmp && \
    unzip trojan-go.zip && \
    # Проверьте, что бинарник существует
    ls -la && \
    # Найдите бинарник и переместите его
    mv $(ls -1 trojan-go* | head -n 1) /usr/local/bin/trojan-go && \
    chmod +x /usr/local/bin/trojan-go && \
    rm -rf /tmp/*

# Скопируйте конфигурационный файл
COPY config.json /etc/trojan/config.json

# Откройте порт 443
EXPOSE 443

# Запустите сервер
CMD ["trojan-go", "-config", "/etc/trojan/config.json"]
