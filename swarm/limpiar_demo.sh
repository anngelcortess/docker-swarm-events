#!/bin/bash

docker service rm webdemo 2>/dev/null
docker service rm swarm-container-events 2>/dev/null
docker service rm swarm-service-events 2>/dev/null

docker config rm swarm_event_listener 2>/dev/null

echo "Servicios y configuración eliminados."
docker service ls
