ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}-alpine

RUN apk update && \
    apk add --no-cache curl ca-certificates openssl git tar unzip bash ffmpeg gettext musl-locales musl-locales-lang

ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN adduser -D -h /home/container container

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./python.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
