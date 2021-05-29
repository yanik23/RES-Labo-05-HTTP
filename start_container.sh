for container in "$@"
do
    docker start $container
    docker exec $container serf agent -node=serf-agent-$container -bind=$(docker inspect $container --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}') &
    docker exec $container serf join $(docker inspect apache_rp --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

done