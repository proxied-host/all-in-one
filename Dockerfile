FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION

RUN echo aaaeeeooois "$NODE_VERSION"

RUN apt update && \
    apt install -y curl software-properties-common locales git && \
    useradd -d /home/container -m container

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN curl -sL $X_URL | bash - && \
    apt -y install nodejs ffmpeg make build-essential && \
    npm i -g npm@latest yarn@latest pm2@latest typescript@latest

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]