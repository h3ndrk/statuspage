#!/bin/sh

docker run --detach --restart=always --name statuspage \
    -v /root/statuspage/config.yml:/app/config.yml:ro \
    -e "TZ=Europe/Berlin" \
    -p 127.0.0.1:10080:8080 statuspage
