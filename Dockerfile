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

ENV DRIVE_SYNC_FOLDER=/ REPEAT=60 DRIVE_NAME=google-drive BI_DIRECTIONAL_SYNC=FALSE

COPY ./rclone.conf /root/.config/rclone/rclone.conf.example
COPY ./start /start

# Start sync script
CMD ./start