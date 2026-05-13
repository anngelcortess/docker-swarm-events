# Docker Swarm Events

## Descripción

Este trabajo amplía la maqueta Docker Swarm creada en la práctica anterior incorporando un sistema de captura de eventos.

La maqueta está formada por un clúster Docker Swarm con un nodo manager y dos nodos worker. Sobre el clúster se despliega una aplicación de prueba basada en `nginx:alpine`.

El objetivo de esta ampliación es detectar eventos relacionados con servicios y contenedores de Docker Swarm y enviar una notificación por Telegram cuando se produzcan.

## Vídeo de demostración

Enlace al vídeo:

https://youtube.com/XXXXXXXX

## Maqueta utilizada

- Nodo manager: manager
- Nodo worker 1: worker1
- Nodo worker 2: worker2
- Aplicación demo: servicio `webdemo`
- Imagen usada: `nginx:alpine`
- Puerto publicado: `8080:80`

## Eventos monitorizados

Se monitorizan eventos de contenedores:

- create
- start
- stop
- die
- destroy
- restart

También se monitorizan eventos de servicios:

- create
- update
- remove

## Funcionamiento

El sistema utiliza `docker events` para escuchar eventos en tiempo real.

Cuando se detecta un evento, el script `swarm-event-listener.sh` obtiene información del evento y envía una notificación mediante Telegram.

Los datos sensibles, como el token del bot y el chat ID, se almacenan usando Docker Secrets.

## Ficheros incluidos

- `scripts/swarm-event-listener.sh`: script principal de captura de eventos.
- `swarm/crear_secrets.sh`: creación de secretos de Telegram.
- `swarm/desplegar_monitor_eventos.sh`: despliegue de los monitores de eventos.
- `swarm/desplegar_demo.sh`: despliegue de la aplicación de demostración.
- `swarm/limpiar_demo.sh`: eliminación de la demo y de los monitores.

## Ejecución

Crear los secretos:

```bash
./swarm/crear_secrets.sh
