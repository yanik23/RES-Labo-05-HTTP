
#!/bin/bash

echo "building containers"
docker build -t res/jl_apache_php docker-images/apache-php-image/
docker build -t res/jl_express_dynamic docker-images/express-image/
docker build -t res/jl_apache_rp docker-images/apache-reverse-proxy/

static_ip_array=()
dynamic_ip_array=()
echo "starting static servers"
for i in 1 2 3 4
do
    docker run -d --name static$i res/jl_apache_php
    static_ip_array+=$(docker inspect static$i --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'):80,
done

static_ips=${static_ip_array[@]}
static_ips=${static_ips%,}

echo $static_ips
echo "starting dynamic servers"

for i in 1 2 3 4
do
    docker run -d --name dynamic$i res/jl_express_dynamic
    dynamic_ip_array+=$(docker inspect dynamic$i --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'):3000,
done

dynamic_ips=${dynamic_ip_array[@]}
dynamic_ips=${dynamic_ips%,}

echo "starting reverse proxy"
echo $dynamic_ips
docker run -d -e STATIC_APP=$static_ips -e DYNAMIC_APP=$dynamic_ips -p 8080:80  --name apache_rp res/jl_apache_rp
apache_rp_ip=$(docker inspect apache_rp --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

echo "starting serf agents"

docker exec apache_rp serf agent -bind=$apache_rp_ip -log-level=debug -event-handler="user=/usr/local/bin/clusterHandler.sh" -event-handler=member-failed="/usr/local/bin/failHandler.sh" &

for i in 1 2 3 4
do
    stat=$(docker inspect static$i --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
    docker exec static$i serf agent -node=serf-agent-static$i -bind=$stat &
    sleep 2
    docker exec static$i serf join $apache_rp_ip
    echo $stat
    docker exec static$i serf event static-join '\'$stat
    sleep 2

    dyn=$(docker inspect dynamic$i --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
    docker exec  dynamic$i serf agent -node=serf-agent-dynamic$i -bind=$dyn &
    sleep 2
    docker exec dynamic$i serf join $apache_rp_ip
     
    docker exec static$i serf event dynamic-join '\'$dyn
    sleep 2
    #update load balancers
done