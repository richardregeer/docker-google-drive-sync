FROM ubuntu:16.04

LABEL maintainer "Richard Regeer" \
      email="rich2309@gmail.com"

RUN apt-get update \
      && apt-get -y install curl unzip \
      && curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip \
      && unzip rclone-current-linux-amd64.zip \
      && cp rclone-*-linux-amd64/rclone /usr/bin/ \
      && chown root:root /usr/bin/rclone \
      && chmod 755 /usr/bin/rclone \
      && apt-get clean \
      && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /rclone-current-linux-amd64.zip

ENV NODE_VERSION 8.11.3

RUN curl -LOk https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz \
      && tar -C /usr/local --strip-components 1 -xzf node-v$NODE_VERSION-linux-x64.tar.gz \
      && rm -rf /node-v$NODE_VERSION-linux-x64.tar.gz \
      && npm install -g pm2

COPY ./lib /usr/local/bin/google-sync/lib
COPY ./etc /usr/local/bin/google-sync/etc
COPY ./etc/rclone.conf /root/.config/rclone/rclone.conf.example

WORKDIR /usr/local/bin/google-sync

CMD ["pm2-runtime" ,"etc/pm2.config.json"]
