#!/bin/bash

docker service create \
  --name webdemo \
  --replicas 2 \
  -p 8080:80 \
  nginx:alpine

echo "Servicio webdemo desplegado."
docker service ls
docker service ps webdemo
