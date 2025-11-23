FROM alpine:latest

# Установка зависимостей
RUN apk --no-cache add curl nginx && \
    mkdir -p /etc/v2ray

# Установка V2Ray
RUN V2RAY_VERSION="v5.13.0" && \
    curl -L -o /tmp/v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/${V2RAY_VERSION}/v2ray-linux-64.zip && \
    unzip /tmp/v2ray.zip -d /usr/local/bin/ && \
    rm -rf /tmp/*

# Конфигурация Nginx
RUN mkdir -p /var/www && echo "OK" > /var/www/index.html
COPY nginx.conf /etc/nginx/nginx.conf

# Копирование конфигов
COPY config.json /etc/v2ray/config.json

EXPOSE 80 443

CMD nginx && v2ray -config /etc/v2ray/config.json
