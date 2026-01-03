#!/bin/bash
sleep 1

NODE_VERSION=$(node -v)
echo "Node.JS version: $NODE_VERSION"

cd /home/container

export PORT=$SERVER_PORT

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

exec ${MODIFIED_STARTUP}
