#!/bin/sh

BOT_TOKEN="$(cat /run/secrets/telegram_token)"
CHAT_ID="$(cat /run/secrets/telegram_chat_id)"
NODE_NAME="$(hostname)"
MODE="${MODE:-container}"

send_telegram() {
    MENSAJE="$1"

    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d "chat_id=${CHAT_ID}" \
        --data-urlencode "text=${MENSAJE}" > /dev/null
}

if [ "$MODE" = "service" ]; then

    docker events \
        --filter type=service \
        --filter scope=swarm \
        --filter event=create \
        --filter event=update \
        --filter event=remove \
        --format '{{json .}}' | while read EVENTO
    do
        ACCION="$(echo "$EVENTO" | jq -r '.Action // .status')"
        SERVICIO="$(echo "$EVENTO" | jq -r '.Actor.Attributes.name // .Actor.ID')"
        FECHA="$(date '+%Y-%m-%d %H:%M:%S')"

        MENSAJE="EVENTO SWARM
Tipo: Servicio
Acción: $ACCION
Servicio: $SERVICIO
Nodo monitor: $NODE_NAME
Fecha: $FECHA"

        echo "$MENSAJE"
        send_telegram "$MENSAJE"
    done

else

    docker events \
        --filter type=container \
        --filter event=create \
        --filter event=start \
        --filter event=stop \
        --filter event=die \
        --filter event=destroy \
        --filter event=restart \
        --filter label=com.docker.swarm.service.name \
        --format '{{json .}}' | while read EVENTO
    do
        ACCION="$(echo "$EVENTO" | jq -r '.Action // .status')"
        ID_CONTENEDOR="$(echo "$EVENTO" | jq -r '(.id // .Actor.ID // "sin-id")[0:12]')"
        SERVICIO="$(echo "$EVENTO" | jq -r '.Actor.Attributes["com.docker.swarm.service.name"] // "sin-servicio"')"
        TAREA="$(echo "$EVENTO" | jq -r '.Actor.Attributes["com.docker.swarm.task.name"] // "sin-tarea"')"
        IMAGEN="$(echo "$EVENTO" | jq -r '.from // .Actor.Attributes.image // "sin-imagen"')"
        FECHA="$(date '+%Y-%m-%d %H:%M:%S')"

        MENSAJE="EVENTO SWARM
Tipo: Contenedor
Acción: $ACCION
Servicio: $SERVICIO
Tarea: $TAREA
Contenedor: $ID_CONTENEDOR
Imagen: $IMAGEN
Nodo: $NODE_NAME
Fecha: $FECHA"

        echo "$MENSAJE"
        send_telegram "$MENSAJE"
    done

fi
