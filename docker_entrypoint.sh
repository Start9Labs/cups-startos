#!/bin/sh

set -euo pipefail

cd /root

lighttpd -f /etc/lighttpd/httpd.conf
exec catatonit cups
