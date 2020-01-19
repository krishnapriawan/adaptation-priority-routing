# Base python 2.7 build, inspired by
# https://github.com/crosbymichael/python-docker/blob/master/Dockerfile
FROM ubuntu:16.04
MAINTAINER Michael Twomey, mick@twomeylee.name

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    gcc \
    git \
    libpq-dev \
    make \
    python-pip \
    python2.7 \
    python2.7-dev \
    python-tk \
    ssh \
    && apt-get autoremove \
    && apt-get clean

# Install Java.
RUN \
    apt-get update && \
    apt-get install -y openjdk-9-jre && \
    rm -rf /var/lib/apt/lists/*
  
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-9-oracle

ENV SUMO_VERSION 0.31.0
ENV SUMO_HOME /opt/sumo
ENV SUMO_USER krishna

# Install system dependencies.
RUN apt-get update && apt-get -qq install \
    wget \
    g++ \
    make \
    libxerces-c-dev \
    libfox-1.6-0 libfox-1.6-dev \
    git \
    vim \
    x11-apps

# Download and extract source code
RUN wget http://downloads.sourceforge.net/project/sumo/sumo/version%20$SUMO_VERSION/sumo-src-$SUMO_VERSION.tar.gz      
RUN tar xzf sumo-src-$SUMO_VERSION.tar.gz && \
    mv sumo-$SUMO_VERSION $SUMO_HOME && \
    rm sumo-src-$SUMO_VERSION.tar.gz

# Configure and build from source.
RUN cd $SUMO_HOME && ./configure && make install

RUN adduser $SUMO_USER --disabled-password

COPY . /app
WORKDIR /app

RUN python -m pip install --upgrade pip wheel
RUN pip install numpy matplotlib
RUN python setup.py install
