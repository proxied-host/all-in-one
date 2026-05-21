FROM debian:bookworm-slim@sha256:0104b334637a5f19aa9c983a91b54c89887c0984081f2068983107a6f6c21eeb

ARG TARGETARCH
ARG JAVA_VERSION

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates openssl git tar unzip bash ffmpeg gettext locales iproute2

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/*

ENV LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN curl --retry 3 -Lfso /tmp/graalvm.tar.gz "https://download.oracle.com/graalvm/${JAVA_VERSION}/latest/graalvm-jdk-${JAVA_VERSION}_linux-$(if [ "${TARGETARCH}" = "arm64" ]; then echo "aarch64"; else echo "x64"; fi)_bin.tar.gz" && \
    mkdir -p /opt/java/graalvm && \
    tar -xf /tmp/graalvm.tar.gz -C /opt/java/graalvm --strip-components=1 && \
    rm /tmp/graalvm.tar.gz

ENV JAVA_HOME=/opt/java/graalvm
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN useradd -d /home/container -m container

USER container
ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

COPY ./java.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
