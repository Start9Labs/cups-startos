FROM alpine:latest

EXPOSE 59001 80

RUN apk add --no-cache bash lighttpd curl catatonit && \
    rm -f /var/cache/apk/*
ARG ARCH
ADD ./cups-messenger/target/${ARCH}-unknown-linux-musl/release/cups /usr/local/bin/cups
RUN chmod a+x /usr/local/bin/cups
ADD ./httpd.conf /etc/lighttpd/httpd.conf
ADD ./cups-messenger-ui/www /var/www/cups
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
