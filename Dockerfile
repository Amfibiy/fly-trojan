FROM alpine:latest

RUN apk --no-cache add trojan-go && \
    mkdir -p /etc/trojan

COPY config.json /etc/trojan/config.json

EXPOSE 443

CMD ["trojan-go", "-config", "/etc/trojan/config.json"]
