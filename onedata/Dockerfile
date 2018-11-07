FROM ubuntu:16.04

LABEL maintainer=rvanharen
LABEL version=0.1

# update repositories
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y curl apt-utils
WORKDIR /opt
# Install oneclient version compatible with our provider
RUN curl -sSL http://packages.onedata.org/onedata.gpg.key | apt-key add -
RUN echo "deb [arch=amd64] http://packages.onedata.org/apt/ubuntu/xenial xenial main" > /etc/apt/sources.list.d/onedata.list
RUN echo "deb-src [arch=amd64] http://packages.onedata.org/apt/ubuntu/xenial xenial main" >> /etc/apt/sources.list.d/onedata.list
RUN apt-get -y update && apt-get install -y oneclient=18.02.0.rc9-1
RUN mkdir -p /mnt/oneclient
ENV MOUNTPOINT /mnt/oneclient
COPY onedata-put.sh /opt/onedata-put.sh

ENTRYPOINT ["/bin/bash"]
