FROM arm32v7/alpine

EXPOSE 59001 80

RUN apk add lighttpd
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing catatonit

ADD ./cups-messenger/target/armv7-unknown-linux-musleabihf/release/cups /usr/local/bin/cups
RUN chmod a+x /usr/local/bin/cups
ADD ./httpd.conf /etc/lighttpd/httpd.conf
ADD ./cups-messenger-ui/www /var/www/cups
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
