#!/bin/bash

docker config rm swarm_event_listener 2>/dev/null

docker config create swarm_event_listener scripts/swarm-event-listener.sh

docker service create \
  --name swarm-container-events \
  --mode global \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock,readonly \
  --config source=swarm_event_listener,target=/event-listener.sh,mode=0555 \
  --secret telegram_token \
  --secret telegram_chat_id \
  --hostname '{{.Node.Hostname}}' \
  --env MODE=container \
  docker:cli \
  sh -c "apk add --no-cache curl jq > /dev/null && /event-listener.sh"

docker service create \
  --name swarm-service-events \
  --replicas 1 \
  --constraint 'node.role == manager' \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock,readonly \
  --config source=swarm_event_listener,target=/event-listener.sh,mode=0555 \
  --secret telegram_token \
  --secret telegram_chat_id \
  --hostname '{{.Node.Hostname}}' \
  --env MODE=service \
  docker:cli \
  sh -c "apk add --no-cache curl jq > /dev/null && /event-listener.sh"

echo "Monitores de eventos desplegados."
docker service ls
