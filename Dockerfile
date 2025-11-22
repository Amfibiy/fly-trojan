FROM alpine:latest

RUN apk --no-cache add curl openssl lighttpd netcat-openbsd && \
    mkdir -p /etc/trojan

RUN TROJAN_GO_VERSION="v1.7.0" && \
    TROJAN_GO_URL="https://github.com/p4gefau1t/trojan-go/releases/download/${TROJAN_GO_VERSION}/trojan-go-linux-amd64.zip" && \
    curl -L -o /tmp/trojan-go.zip ${TROJAN_GO_URL} && \
    cd /tmp && \
    unzip trojan-go.zip && \
    mv trojan-go /usr/local/bin/trojan-go && \
    chmod +x /usr/local/bin/trojan-go && \
    rm -rf /tmp/*

RUN openssl req -newkey rsa:2048 -nodes -keyout /etc/trojan/private.key -x509 -days 365 -out /etc/trojan/cert.crt -subj "/CN=fly-trojan.onrender.com"

RUN echo 'server.document-root = "/var/www"' > /etc/lighttpd/lighttpd.conf && \
    echo 'server.port = 80' >> /etc/lighttpd/lighttpd.conf && \
    mkdir -p /var/www && \
    echo "OK" > /var/www/index.html

COPY config.json /etc/trojan/config.json
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 443
CMD ["/start.sh"]
