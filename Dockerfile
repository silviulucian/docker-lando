FROM docker:19.03

# Packages and dependencies
RUN set -eux; \
  apk update; \
  apk add --no-cache \
    sudo \
    bash \
    curl \
    wget \
    unzip \
    nodejs \
    npm \
    yarn \
    git \
    iptables \
    procps \
    openrc \
    py-pip \
    python-dev \
    libffi-dev \
    openssh \
    openssl \
    openssl-dev \
    gcc \
    libc-dev \
    make \
    zlib \
    libgcc

RUN set -eux; \
    apk add --no-cache -t .deps ca-certificates; \
    # Install glibc on Alpine (required by docker-compose) from https://github.com/sgerrand/alpine-pkg-glibc
    # See also https://github.com/gliderlabs/docker-alpine/issues/11
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk; \
    apk add glibc-2.29-r0.apk; \
    rm glibc-2.29-r0.apk; \
    apk del --purge .deps

# Required for docker-compose to find zlib
ENV LD_LIBRARY_PATH=/lib:/usr/lib

# Install Docker Compose as per https://docs.docker.com/compose/install/
RUN set -eux; \
    apk add --no-cache -t .deps ca-certificates; \
    curl -fsSL -o /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)"; \
    chmod a+rx /usr/local/bin/docker-compose; \
    # Clean-up
    apk del --purge .deps; \
    # Basic check it works
    docker-compose version

# Build Lando
RUN set -eux; \
  curl -fsSL -o lando-3.0.0-rc.23.zip "https://github.com/lando/lando/archive/v3.0.0-rc.23.zip"; \
  unzip lando-3.0.0-rc.23.zip; \
  cd lando-3.0.0-rc.23; \
  yarn install; \
  yarn run pkg:cli; \
  cp -R build/cli /usr/share/lando; \
  ln -sf /usr/share/lando/bin/lando.js /usr/local/bin/lando; \
  chmod 755 -R /usr/share/lando
