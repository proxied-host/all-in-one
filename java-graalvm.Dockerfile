FROM alpine:3.22

ARG TARGETARCH
ARG JAVA_VERSION

RUN apk update && \
    apk add --no-cache curl ca-certificates openssl git tar unzip bash ffmpeg gettext musl-locales musl-locales-lang

ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN curl --retry 3 -Lfso /tmp/graalvm.tar.gz "https://download.oracle.com/graalvm/${JAVA_VERSION}/latest/graalvm-jdk-${JAVA_VERSION}_linux-$(if [ "${TARGETARCH}" = "arm64" ]; then echo "aarch64"; else echo "x64"; fi)_bin.tar.gz" && \
    mkdir -p /opt/java/graalvm && \
    tar -xf /tmp/graalvm.tar.gz -C /opt/java/graalvm --strip-components=1 && \
    rm /tmp/graalvm.tar.gz

ENV JAVA_HOME /opt/java/graalvm
ENV PATH "${JAVA_HOME}/bin:${PATH}"

RUN adduser -D -h /home/container container

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./java.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
