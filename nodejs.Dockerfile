FROM ubuntu:24.04@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54
ARG DEBIAN_FRONTEND=noninteractive

ARG TARGETARCH
ARG NODE_VERSION
ARG X_URL=https://deb.nodesource.com/setup_$NODE_VERSION.x
ARG BUN_VERSION=v1.2.22

RUN apt update && \
    apt install -y curl software-properties-common default-jre locales git unzip && \
    useradd -d /home/container -m container

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN curl -sL $X_URL | bash - && \
    apt install -y nodejs g++ build-essential ffmpeg
RUN npm i -g pm2 pnpm

# Install yarn
RUN apt remove cmdtest
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && \
    apt install yarn

# Install bun
RUN case ${TARGETARCH} in 'amd64') TARGET=linux-x64-baseline;; 'arm64') TARGET=linux-aarch64;; esac && \
    echo "TARGETARCH=${TARGETARCH}" && \
    echo "TARGET=$TARGET" && \
    curl -fL -o bun.zip https://github.com/oven-sh/bun/releases/download/bun-${BUN_VERSION}/bun-$TARGET.zip && \
    unzip bun.zip && \
    mv bun-$TARGET/bun /usr/local/bin/bun && \
    rm -r bun.zip bun-$TARGET

# Lib dependencies for puppeteer
RUN apt install -y libxdamage1 libgbm1

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./nodejs.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
