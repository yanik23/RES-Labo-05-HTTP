
#!/bin/bash
docker run -d --name $1 $2 

ip=$(docker inspect $1 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')


docker exec $1 serf agent  -bind=$ip &
docker exec $1 serf join $(docker inspect apache_rp --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

case $3 in
    static)
        docker exec $1 serf event static-join '\'$ip
    ;;

    dynamic)
        docker exec $1 serf event dynamic-join '\'$ip
    ;;
esac
