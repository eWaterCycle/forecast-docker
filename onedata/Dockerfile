FROM ubuntu:16.04

LABEL maintainer=rvanharen
LABEL version=0.1

# update repositories
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y curl
WORKDIR /opt
RUN curl -O  http://get.onedata.org/oneclient.sh
RUN bash oneclient.sh
COPY onedata-put.sh /opt/onedata-put.sh

ENTRYPOINT ["/bin/bash"]
