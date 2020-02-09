FROM docker:18

RUN apk update
RUN apk add curl unzip nodejs npm yarn git iptables procps
RUN curl -fsSL -o lando-3.0.0-rc.23.zip https://github.com/lando/lando/archive/v3.0.0-rc.23.zip
RUN unzip lando-3.0.0-rc.23.zip
RUN cd lando-3.0.0-rc.23 && yarn install && yarn run pkg:cli

RUN cp -R lando-3.0.0-rc.23/build/cli /usr/share/lando
RUN chmod 755 -R /usr/share/lando
RUN ln -sf /usr/share/lando/bin/lando.js /usr/local/bin/lando
RUN lando config
RUN lando version
