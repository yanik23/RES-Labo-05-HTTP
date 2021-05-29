docker run -d  --name staticxx res/jl_apache_php
docker exec  staticxx serf agent -bind=$(docker inspect staticxx --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}') &
docker exec -it staticxx serf join $(docker inspect apache_rp --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

sleep 10

docker kill staticxx
docker rm staticxx
