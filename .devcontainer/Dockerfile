FROM docker.io/archlinux
LABEL maintainer="antany84@gmail.com"
ENV TZ="America/New_York"

ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV TZ="America/New_York"

RUN yes | pacman -Syu && yes | pacman -S iproute2 curl vim sudo which git

RUN groupadd -g ${USER_GID} devuser && \
    groupadd sudo && \
    useradd -m -s /bin/bash -u ${USER_UID} -g ${USER_GID} -G sudo devuser && \
    echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


RUN curl -L https://api.adoptium.net/v3/binary/latest/17/ga/linux/x64/jdk/hotspot/normal/adoptium \
| tar xvz -C /opt/ 

RUN ln -sf /opt/`ls /opt/ | grep jdk*` /opt/java \
&& chmod a+rx -R /opt/`ls /opt/ | grep jdk*` 

ENV JAVA_HOME="/opt/java"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN mkdir /workspace 
RUN chown -R devuser:devuser /workspace

WORKDIR /workspace