FROM ubuntu:18.04


RUN apt update && apt install -y wget gnupg

RUN echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | \
        tee /etc/apt/sources.list.d/100-ubnt-unifi.list && \
    wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | apt-key add - && \
    echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | \
        tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

RUN apt update && apt remove -y wget gnupg && apt install -y \
        haveged \
        ca-certificates \
        apt-transport-https \
        unifi && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'UNIFI_USER=root' | tee /etc/default/unifi && \
    chown -R root /var/lib/unifi /var/log/unifi /var/run/unifi

COPY unifi-daemon-wrapper.sh /

EXPOSE 8080/tcp 8443/tcp

CMD ["./unifi-daemon-wrapper.sh"]