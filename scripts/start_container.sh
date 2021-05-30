#!/bin/bash
programname=$0

function usage {
    echo "usage : $programname [container_name/id] [static|dynamic]"
    echo "  container_name/id   : the name of the stopped container"
    echo "  static              : if the container is a static apache server"
    echo "  dynamic             : if the container is a dynamic server"
    exit 1
}
if [ $# == 0 ]; then
    usage
fi

docker start $1 $2
ip=$(docker inspect $1 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
docker exec $1 serf agent   &
docker exec $1 serf join $(docker inspect apache_rp --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

case $2 in
    static)
        docker exec $1 serf event static-join '\'$ip
    ;;

    dynamic)
        docker exec $1 serf event dynamic-join '\'$ip
    ;;
esac
