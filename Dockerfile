FROM ubuntu:noble

# 删除基础用户
RUN userdel -r ubuntu || true

# 创建应用用户
RUN useradd -m -u 1000 lingyicute

# 安装核心组件
RUN apt-get update && yes | unminimize && apt-get dist-upgrade -y && \
    apt-mark hold snapd firefox fwupd && \
    apt-get install -y jq curl git openssh-server openssh-client pbzip2 sudo wget nano tmux \
       util-linux dos2unix vim tar gzip kde-plasma-desktop && \
    apt-get autoremove -y && apt-get clean && \
    curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc > /etc/apt/trusted.gpg.d/ngrok.asc && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" > /etc/apt/sources.list.d/ngrok.list && \
    apt-get update && apt-get install -y ngrok && \
    echo '#1000 ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99-nopasswd-uid1000 && \
    chmod 440 /etc/sudoers.d/99-nopasswd-uid1000 && \
    chown -R lingyicute:lingyicute /home/lingyicute && \
    apt-get install tigervnc-standalone-server -y && apt-get clean

# 安装noVNC
RUN git clone https://github.com/novnc/noVNC /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

ENTRYPOINT ["tmux"]
