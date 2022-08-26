sleep 1

clear

NODE_VERSION=$(node -v)
echo "Node.JS version: $NODE_VERSION"

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

cd /home/container

${MODIFIED_STARTUP}