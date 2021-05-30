#!/bin/bash
docker ps -q | xargs -n 1 docker inspect --format '«{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';