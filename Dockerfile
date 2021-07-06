FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

# install ubuntu packages
RUN apt-get update &&\
    apt-get -y upgrade &&\
    apt-get install -y apt-utils openssh-server x2goserver x2goserver-xsession xterm &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# configure system
RUN sed -i 's/^X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config && \
    sed -i "s/Port 22/#Port 22/g" /etc/ssh/sshd_config && \
    sed -i "s/#X11UseLocalhost yes/X11UseLocalhost no/g" /etc/ssh/sshd_config && \
    sed -i "s/loglevel=notice/loglevel=debug/g" /etc/x2go/x2goserver.conf && \
    echo "Port 2222" >> /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd
COPY container_init.sh /container_init.sh
COPY run.sh /run.sh
RUN chmod +x /*.sh

EXPOSE 2222
CMD ["/run.sh"]
