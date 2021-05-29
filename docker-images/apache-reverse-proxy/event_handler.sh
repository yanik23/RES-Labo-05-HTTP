#!/bin/bash



EVENT=${SERF_EVENT} 
echo
echo "New event: $EVENT. Data follows..."
while read line; do
    printf "${line}\n"
done
case $EVENT in

    "member-join")
        echo -n "join"
    ;;

    "member-leave")
        echo -n "leave"
    ;;
    "member-failed")
        echo -n "failed"
    ;;
esac