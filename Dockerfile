FROM ubuntu:trusty

RUN \
  apt-get update && \
  apt-get -y install \
    build-essential \
    wget \
    curl \
    openssh-client \
    unzip \
    jq \
    git

 ENV GOPATH /go
 ENV PATH /go/bin:/usr/local/go/bin:$PATH
 RUN \
  wget https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/go1.7.4.linux-amd64.tar.gz -C /usr/local && \
  mkdir $GOPATH && \
  rm -rf /tmp/*

# Install the cf CLI
ARG version
RUN wget -q -O cf.deb "https://cli.run.pivotal.io/stable?release=debian64&version=${version}&source=github-rel"
RUN dpkg -i cf.deb

# Install the CF Networking CLI plugin
RUN wget -q -O /tmp/network-policy-plugin "https://github.com/cloudfoundry-incubator/cf-networking-release/releases/download/v0.14.0/network-policy-plugin-linux64" && \
  chmod +x /tmp/network-policy-plugin && \
  cf install-plugin /tmp/network-policy-plugin -f && \
  rm -rf /tmp/*
