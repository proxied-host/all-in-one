sleep 1

NODE_VERSION=$(node -v)
echo "Node.JS version: $NODE_VERSION"

cd /home/container

export PORT=$SERVER_PORT

if [ ! -f ".noyarn" ] && [[ ! -d ".yarn" || "$(which yarn)" =~ "/usr/bin/yarn" ]]
then
    echo "Yarn is not installed. Do you want to install it? (y/n):"
    read SHOULD_INSTALL

    if [[ $SHOULD_INSTALL =~ ^[Yy]$ ]]
    then
        echo "Installing Yarn..."
        curl -o- -L https://yarnpkg.com/install.sh | bash
        sleep 1
        source ~/.bashrc

        if [[ $(which yarn) == "/usr/bin/yarn" ]]
        then
            echo "Wrong yarn installation path detected. Restarting the server in 3 seconds." 
            sleep 3
            exit
        fi
    else
        echo "Okay, if you want to install yarn later - delete '.noyarn' file."
        touch .noyarn
    fi
fi

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}
