ARG JAVA_VERSION

FROM openjdk:${JAVA_VERSION}
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y curl software-properties-common locales git unzip && \
    useradd -d /home/container -m container

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt install -y g++ build-essential ffmpeg

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./java.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
