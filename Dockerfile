FROM debian:bookworm

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
      xrdp \
      xfce4 \
      xfce4-terminal \
      dbus-x11 \
      sudo \
      wget \
      curl \
      git \
      firefox-esr \
      fonts-wqy-zenhei && \
    rm -rf /var/lib/apt/lists/*

# create a user (change username/password here)
RUN useradd -m -s /bin/bash rdpuser && \
    echo "rdpuser:changeme123" | chpasswd && \
    adduser rdpuser sudo && \
    adduser xrdp ssl-cert

# set xfce as the default desktop session for this user
RUN echo "xfce4-session" > /home/rdpuser/.xsession && \
    chown rdpuser:rdpuser /home/rdpuser/.xsession

# xrdp needs its own startup script to launch xfce properly
RUN echo '#!/bin/sh' > /etc/xrdp/startwm.sh && \
    echo 'exec /bin/dbus-launch --exit-with-session xfce4-session' >> /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

EXPOSE 3389

CMD service xrdp start && tail -f /var/log/xrdp.log
