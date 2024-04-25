FROM ubuntu:22.04@sha256:6d7b5d3317a71adb5e175640150e44b8b9a9401a7dd394f44840626aff9fa94d
ARG DEBIAN_FRONTEND=noninteractive

ARG PYTHON_VERSION
ARG PYTHON_VERSION_SHORT
ARG DOWNLOAD_URL=https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz

RUN apt update && \
    apt install -y curl wget software-properties-common default-jre locales git && \
    useradd -d /home/container -m container

# additional dependencies for python
RUN apt update && \
    apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# download and install python
WORKDIR /tmp
RUN curl -sLO $DOWNLOAD_URL && \
    tar -xf Python-$PYTHON_VERSION.tgz

WORKDIR /tmp/Python-$PYTHON_VERSION
RUN ./configure --enable-optimizations --enable-loadable-sqlite-extensions && \
    make PROFILE_TASK="-m test.regrtest --pgo -j8" -j8 && \
    make altinstall

# update alternatives
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python$PYTHON_VERSION_SHORT 1 && \
    update-alternatives --set python /usr/local/bin/python$PYTHON_VERSION_SHORT

# install pip
RUN python -m ensurepip --upgrade && \
    python -m pip install --upgrade pip

ENV USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./python.entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
