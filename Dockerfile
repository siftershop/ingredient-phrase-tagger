FROM sifteracr.azurecr.io/crfpp:0.2
LABEL maintainer="Ojas Kale <ojas.kale@egen.solutions>"

ENV TZ=America/Chicago \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONIOENCODING=utf-8

ARG BUILD_DATE
ENV VCS_URL https://github.com/siftershop/ingredient-phrase-tagger.git
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="$VCS_URL" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

RUN apt-get update -y && \
    apt-get install -y git software-properties-common wget libssl-dev libffi-dev openssl build-essential zlib1g-dev curl python3-dev  python3-setuptools python3-pip && \
    add-apt-repository ppa:deadsnakes/ppa && \
    wget https://www.python.org/ftp/python/3.8.13/Python-3.8.13.tgz && \
    tar xzvf Python-3.8.13.tgz && \
    cd Python-3.8.13 && \
    ./configure --with-zlib && \
    make && \
    make install && \
    rm -Rf /usr/share/doc && \
    rm -Rf /usr/share/man && \
    apt-get autoremove -y && \
    cd .. && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --upgrade pip

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ADD . /app
WORKDIR /app

