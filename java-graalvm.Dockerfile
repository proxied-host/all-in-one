FROM debian:bookworm-slim@sha256:98f4b71de414932439ac6ac690d7060df1f27161073c5036a7553723881bffbe

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
