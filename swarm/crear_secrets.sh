#!/bin/bash

echo "Introduce el token del bot de Telegram:"
read -s TOKEN

echo "Introduce el chat ID de Telegram:"
read CHAT_ID

printf "$TOKEN" | docker secret create telegram_token -
printf "$CHAT_ID" | docker secret create telegram_chat_id -

echo "Secrets creados correctamente."
docker secret ls
