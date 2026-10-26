ARG NODE_VERSION

FROM node:${NODE_VERSION}-alpine3.24

RUN apk update && \
    apk add --no-cache curl ca-certificates openssl git tar unzip bash ffmpeg gettext musl-locales musl-locales-lang gcompat

ENV LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV BUN_INSTALL=/usr/local
ADD https://bun.sh/install /tmp/bun-install.sh
RUN bash /tmp/bun-install.sh

RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg && \
    rm -rf /opt/yarn-v* && \
    bun add -g pnpm yarn

RUN adduser -D -h /home/container container

USER container
ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

COPY ./nodejs.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
