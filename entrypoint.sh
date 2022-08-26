sleep 1

cd /home/container

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo to install nvm, run the following command:
echo "curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}