
#!/bin/bash
programname=$0
nbstatic=$1
nbdynamic=$2

function usage (){
    echo "usage : $programname  [nbstatic]  [nbdynamic]"
    echo "  nbstatic                : number of static servers to start"
    echo "  dynamic                 : number of dynamic servers to start"
    exit 1
}

function get_ip(){
    container=$1
    ip_returned=$(docker inspect $container --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
}


if [ $# == 0 ] || [ $# == 1 ] ; then
    usage
fi

echo "building containers"
docker build -t res/jl_apache_php ../docker-images/apache-php-image/
docker build -t res/jl_express_dynamic ../docker-images/express-image/
docker build -t res/jl_apache_rp ../docker-images/apache-reverse-proxy/

static_ip_array=()
dynamic_ip_array=()
echo "starting static servers"
for ((i=0;i<$nbstatic;i++))
do
    docker run -d --name static$i res/jl_apache_php
    get_ip static$i
    static_ip_array+=$ip_returned:80,
done

static_ips=${static_ip_array[@]}
static_ips=${static_ips%,}

echo $static_ips
echo "starting dynamic servers"

for ((i=0;i<$nbdynamic;i++))
do
    docker run -d --name dynamic$i res/jl_express_dynamic
    get_ip dynamic$i
    dynamic_ip_array+=$ip_returned:3000,
done

dynamic_ips=${dynamic_ip_array[@]}
dynamic_ips=${dynamic_ips%,}

echo "starting reverse proxy"
echo $dynamic_ips
docker run -d -e STATIC_APP=$static_ips -e DYNAMIC_APP=$dynamic_ips -p 8080:80  --name apache_rp res/jl_apache_rp
get_ip apache_rp
apache_rp_ip=$ip_returned

echo "starting serf agents"

docker exec apache_rp serf agent -bind=$apache_rp_ip -log-level=debug -event-handler="user=/usr/local/bin/clusterHandler.sh" -event-handler=member-failed="/usr/local/bin/failHandler.sh" &

for ((i=0;i<$nbstatic;i++))
do
    get_ip static$i
    docker exec static$i serf agent -node=serf-agent-static$i -bind=$ip_returned &
    sleep 1
    docker exec static$i serf join $apache_rp_ip
    sleep 1
    docker exec static$i serf event static-join '\'$ip_returned
    sleep 1
done

for ((i=0;i<$nbdynamic;i++))
do
    get_ip dynamic$i
    docker exec  dynamic$i serf agent -node=serf-agent-dynamic$i -bind=$ip_returned &
    sleep 1
    docker exec dynamic$i serf join $apache_rp_ip
    sleep 1
    docker exec static$i serf event dynamic-join '\'$ip_returned
    sleep 1
done

