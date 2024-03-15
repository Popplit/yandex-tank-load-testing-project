FROM ubuntu:focal
MAINTAINER Yandex Load Team <load-public@yandex-team.ru>
ARG VERSION
ARG BRANCH=master

# Packages for Yandex Tank
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update -q && \
  apt-get install --no-install-recommends -yq \
      sudo   \
      vim    \
      wget   \
      curl   \
      less   \
      iproute2 \
      software-properties-common \
      telnet \
      atop   \
      openssh-client \
      git          \
      gpg-agent    \
      python3-pip \
      make

# Cache clear
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# Yandex Tank install
ENV BUILD_DEPS="python3-dev build-essential gfortran libssl-dev libffi-dev"
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -yq --no-install-recommends ${BUILD_DEPS} && \
  pip3 install --upgrade setuptools && \
  pip3 install --upgrade pip && \
  pip3 install https://github.com/BlackHobbiT/yandex-tank/archive/refs/heads/master.zip && \
  apt-get autoremove -y ${BUILD_DEPS} && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/* /root/.cache/*

# Go install
RUN wget https://dl.google.com/go/go1.21.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Pandora install
RUN git clone https://github.com/yandex/pandora.git
WORKDIR pandora
RUN make deps
RUN go install
ENV PATH=$PATH:/root/go/bin

WORKDIR /app
COPY config/load.yaml /app/load.yaml
ENTRYPOINT ["/usr/local/bin/yandex-tank"]