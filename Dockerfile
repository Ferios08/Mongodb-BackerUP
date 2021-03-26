FROM ubuntu:bionic
 
RUN apt update && apt install gnupg2 curl cron -y && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" |  tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org-shell mongodb-org-tools && \
    echo "mongodb-org-shell hold" | dpkg --set-selections && \
    echo "mongodb-org-tools hold" | dpkg --set-selections && \
    mkdir -p /mongo-backup

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh
RUN chmod +x run.sh
VOLUME ["/mongo-backup"]
CMD ["/run.sh"]
