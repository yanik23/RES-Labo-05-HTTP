#!/bin/bash



echo
echo "New event:${SERF_EVENT} . Data follows..."

read name ip

case ${SERF_EVENT}  in

    "member-join")
        $(sed -i "s/.*$ip:3000.*/BalancerMember httpd:\/\/$ip:3000/"      /etc/apache2/sites-enabled/001-reverse-proxy.conf)
        $(sed -i "s/.*$ip:80.*/BalancerMember httpd:\/\/$ip:80/"  /etc/apache2/sites-enabled/001-reverse-proxy.conf)
        /etc/init.d/apache2 reload

    ;;

    "member-leave")
        echo -n "leave"
    ;;
    "member-failed")   
        echo "Faillure of $ip"
         
        $(sed -i "s/.*$ip:3000.*/BalancerMember httpd:\/\/$ip:3000 status=D/"      /etc/apache2/sites-enabled/001-reverse-proxy.conf)
        $(sed -i "s/.*$ip:80.*/BalancerMember httpd:\/\/$ip:80 status=D/"  /etc/apache2/sites-enabled/001-reverse-proxy.conf)

        /etc/init.d/apache2 reload

    ;;
esac