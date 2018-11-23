FROM docker:dind
RUN apk update \
 && apk add bash curl openjdk8 git supervisor

# sbt install
ARG SBT_VERSION=1.1.1
RUN curl -x $PROXY_HOST:$PROXY_PORT --output sbt.tgz -L https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz \
 && gunzip sbt.tgz \
 && tar -x -C /usr/local -f sbt.tar \
 && rm -rf sbt.tar


# gitbucket install
ARG GITBUCKET_VERSION=4.20.0
RUN mkdir -p /opt/gitbucket/ \
 && curl -x $PROXY_HOST:$PROXY_PORT --output /opt/gitbucket/gitbucket.war -L https://github.com/gitbucket/gitbucket/releases/download/$GITBUCKET_VERSION/gitbucket.war

RUN ln -s /gitbucket /root/.gitbucket

# docker gitbucket supervisor config
RUN mkdir -p /etc/supervisor.d/
ADD gitbucket.conf /etc/supervisor.d/gitbucket.ini
ADD docker.conf /etc/supervisor.d/docker.ini

# docker insecure registry config
ADD daemon.json /etc/docker/daemon.json

# make logdir
RUN mkdir -p /var/log/gitbucket\
 && mkdir -p /var/log/docker

# make docker group
RUN addgroup docker

VOLUME /gitbucket
EXPOSE 8080

# add path
RUN echo "export PATH=/usr/local/sbt/bin:${PATH}" >> ~/.bash_profile

WORKDIR /root/.gitbucket/
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
