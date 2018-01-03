FROM ndhai2005/oracle-jdk-8

MAINTAINER Hai Nguyen "ndhai2005@gmail.com"

ARG NETBEAN_VER=${NETBEAN_VER:-"8.2"}
ENV NETBEAN_VER=${NETBEAN_VER}

ARG DISPLAY=${DISPLAY:-":0.0"}
ENV DISPLAY=${DISPLAY}

ARG USER_ID=${USER_ID:-1000}
ENV USER_ID=${USER_ID}

ARG GROUP_ID=${GROUP_ID:-1000}
ENV GROUP_ID=${GROUP_ID}
    
## ---- X11 ----
RUN apt-get update && \
    apt-get install -y xauth xorg openbox && \
    apt-get install -y libxext-dev libxrender-dev libxtst-dev nginx

RUN export DISPLAY=${DISPLAY} && \
    useradd developer && \
    export uid=${USER_ID} gid=${GROUP_ID} && \
    mkdir -p /home/developer && \
    mkdir -p /home/developer/workspace && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${USER_ID}:${GROUP_ID}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${USER_ID}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer
    
## ---- Netbeans ----
RUN wget -c http://download.netbeans.org/netbeans/${NETBEAN_VER}/final/bundles/netbeans-${NETBEAN_VER}-linux.sh && \
    chmod +x netbeans-${NETBEAN_VER}-linux.sh && \
    ./netbeans-${NETBEAN_VER}-linux.sh --silent 

# Install Chrome
#RUN wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
#    chmod +x google-chrome-stable_current_amd64.deb && \
#    dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

RUN apt-get clean all && \
    ls /usr/local/ && \
    rm -rf netbeans* && \
    rm -rf google-chrome*

USER developer
ENV HOME /home/developer
WORKDIR /home/developer

CMD "/usr/local/netbeans-${NETBEAN_VER}/bin/netbeans"
