#!/usr/bin/bash


docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker image rm $(docker images --filter=reference=vsc* -aq)
