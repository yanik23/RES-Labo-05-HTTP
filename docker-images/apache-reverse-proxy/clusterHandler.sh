#!/bin/bash

echo
echo "$0 triggered!"
echo
echo "SERF_EVENT is ${SERF_EVENT}"
echo "SERF_SELF_NAME is ${SERF_SELF_NAME}"
echo "SERF_SELF_ROLE is ${SERF_SELF_ROLE}"
echo "SERF_USER_EVENT is ${SERF_USER_EVENT}"
echo
echo "BEGIN event data"
case ${SERF_USER_EVENT} in
    static-join)
            read ip
            $(sed -i "/#staticBalancer/i\                   BalancerMember http:\/\/$ip:80" /etc/apache2/sites-enabled/001-reverse-proxy.conf)
            apachectl -k graceful
    ;;
    dynamic-join)
            read ip
            $(sed -i "/#dynamicBalancer/i\                  BalancerMember http:\/\/$ip:3000" /etc/apache2/sites-enabled/001-reverse-proxy.conf)
            apachectl -k graceful
    ;;
esac


echo "$0 finished!"
echo