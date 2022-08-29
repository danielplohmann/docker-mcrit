FROM ubuntu:20.04

RUN apt-get -y update && apt-get -y install locales locales-all
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
  apt-utils \
  p7zip-full \
  python3.8 \
  python3-pip \
  python3-dev \
  build-essential \
  gcc-multilib \
  git \
  openssh-client \
  inotify-tools \
  zip \
  curl \
  libssl-dev

RUN python3.8 -m pip install -U pip setuptools
RUN mkdir -p /root/.local/lib/python3.8/site-packages/
RUN ln -s /usr/bin/python3.8 /usr/bin/python

# install mcrit
RUN git clone https://github.com/danielplohmann/mcrit.git /opt/mcrit
RUN python -m pip install -r /opt/mcrit/requirements.txt
RUN python -m pip install -e /opt/mcrit

WORKDIR /opt/mcrit
# don't create pyc files and immediately flush (log) buffers
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY ./entry_server.sh /entry_server.sh
COPY ./entry_worker.sh /entry_worker.sh
RUN chmod +x /entry_server.sh /entry_worker.sh