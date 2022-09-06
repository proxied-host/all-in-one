FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION
ARG X_URL=https://deb.nodesource.com/setup_"$NODE_VERSION".x

RUN apt update && \
    apt install -y curl software-properties-common locales git && \
    useradd -d /home/container -m container

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN curl -sL $X_URL | bash - && \
    apt install -y nodejs g++ ffmpeg
RUN npm i -g npm@latest pm2 typescript
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt install -y yarn

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]