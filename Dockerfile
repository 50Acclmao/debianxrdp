FROM debian

RUN dpkg --add-architecture i386 && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
      wine qemu-kvm fonts-wqy-zenhei xz-utils dbus-x11 curl firefox-esr \
      gnome-system-monitor mate-system-monitor git xfce4 xfce4-terminal \
      tightvncserver wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz

RUN mkdir $HOME/.vnc && \
    echo 'admin123@a' | vncpasswd -f > $HOME/.vnc/passwd && \
    echo '/bin/env MOZ_FAKE_NO_SANDBOX=1 dbus-launch xfce4-session' > $HOME/.vnc/xstartup && \
    chmod 600 $HOME/.vnc/passwd && \
    chmod 755 $HOME/.vnc/xstartup

RUN { \
      echo 'whoami'; \
      echo 'cd'; \
      echo "su -l -c 'vncserver :2000 -geometry 1360x768'"; \
      echo 'cd /noVNC-1.2.0'; \
      echo './utils/launch.sh --vnc localhost:7900 --listen 8900'; \
    } >> /luo.sh && \
    chmod 755 /luo.sh

EXPOSE 8900
CMD ["/luo.sh"]
