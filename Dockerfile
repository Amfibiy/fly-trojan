FROM alpine:latest

RUN apk --no-cache add curl openssl && \
    mkdir -p /etc/trojan

# Скачать trojan-go
RUN TROJAN_GO_VERSION="v0.10.6" && \
    TROJAN_GO_URL="https://github.com/p4gefau1t/trojan-go/releases/download/${TROJAN_GO_VERSION}/trojan-go-linux-amd64.zip" && \
    curl -L -o /tmp/trojan-go.zip ${TROJAN_GO_URL} && \
    cd /tmp && \
    unzip trojan-go.zip && \
    mv trojan-go /usr/local/bin/trojan-go && \
    chmod +x /usr/local/bin/trojan-go && \
    rm -rf /tmp/*

# Генерация сертификата
RUN openssl req -newkey rsa:2048 -nodes -keyout /etc/trojan/private.key -x509 -days 365 -out /etc/trojan/cert.crt -subj "/CN=fly-trojan.onrender.com"

COPY config.json /etc/trojan/config.json

EXPOSE 443

CMD ["trojan-go", "-config", "/etc/trojan/config.json"]
