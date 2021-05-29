#!/bin/bash

case ${SERF_EVENT} in
    member-failed)
        read name ip
        $(sed -i "/$ip/d"  /etc/apache2/sites-enabled/001-reverse-proxy.conf)
        apachectl -k graceful
    ;;
esac