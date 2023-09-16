FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION
ARG X_URL=https://deb.nodesource.com/setup_$NODE_VERSION.x

RUN apt update && \
    apt install -y curl software-properties-common default-jre locales git && \
    useradd -d /home/container -m container

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN curl -sL $X_URL | bash - && \
    apt install -y nodejs g++ build-essential ffmpeg
# RUN npm i -g npm@latest pm2

# Install yarn
RUN apt remove cmdtest
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && \
    apt install yarn

# Install bun
RUN curl -fsSL https://bun.sh/install | bash

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./nodejs.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
