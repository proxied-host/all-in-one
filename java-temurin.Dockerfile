FROM alpine:3.22

ARG TARGETARCH
ARG JAVA_VERSION

RUN apk update && \
    apk add --no-cache curl ca-certificates openssl git tar unzip bash ffmpeg gettext musl-locales musl-locales-lang

ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -x && \
    URL="https://api.adoptium.net/v3/binary/latest/${JAVA_VERSION}/ga/alpine-linux/$(if [ "${TARGETARCH}" = "arm64" ]; then echo aarch64; else echo x64; fi)/jdk/hotspot/normal/eclipse?project=jdk" && \
    echo "Downloading from: $URL" && \
    curl --retry 3 -Lfso /tmp/temurin.tar.gz "$URL" && \
    mkdir -p /opt/java/temurin && \
    tar -xf /tmp/temurin.tar.gz -C /opt/java/temurin --strip-components=1 && \
    rm /tmp/temurin.tar.gz

ENV JAVA_HOME /opt/java/temurin
ENV PATH "${JAVA_HOME}/bin:${PATH}"

RUN adduser -D -h /home/container container

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./java.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
