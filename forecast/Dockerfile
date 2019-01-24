# A docker container with openDA & PCR-GLOBWB installed as
# used in the eWaterCycle project

FROM ewatercycle/ewatercycle_forecast_base

LABEL maintainer=ewatercycle
LABEL version=0.2

# update repositories
RUN apt-get -y update && \
apt-get -y upgrade

# Install dependencies
RUN apt-get -y install \
    ant \
    python \
    python-numpy \
    python-jinja2 \
    lsb \
    libjpeg62 \
    sudo \
    default-jdk \
    wget \
    python-thrift \
    python-netcdf4 \
    cython \
    nano \
    gdal-bin \
    git

# set workdir
WORKDIR /usr/src

# download & extract pcraster
LABEL pcraster_version=4.1.0
RUN mkdir -p /usr/src && \
    wget -q -O - "http://downloads.sourceforge.net/project/pcraster/PCRaster/4.1.0/pcraster-4.1.0_x86-64.tar.gz" \
      | tar xCz /usr/src

ENV PATH=/usr/src/pcraster-4.1.0_x86-64/bin:/usr/src/scripts:${PATH}
ENV PYTHONPATH=/usr/src/pcraster-4.1.0_x86-64/python:${PYTHONPATH}

# copy patches inside docker image
RUN mkdir -p /usr/src/patches
COPY patches /usr/src/patches

# install PCR-GLOBWB model
ARG PCR-GLOBWB_model_tag=v2.0_alpha_ewatercycle
RUN git clone https://github.com/eWaterCycle/PCR-GLOBWB_model.git && \
    cd PCR-GLOBWB_model && \
    git checkout tags/v2.0_alpha_ewatercycle 2> /dev/null

RUN cd PCR-GLOBWB_model/model && python setup.py install

# install openDA
RUN mkdir -p /usr/src && \
    wget -q -O - "https://zenodo.org/record/60077/files/openda-ewatercycle.tar.bz2" \
      | tar xCj /usr/src && \
    cd /usr/src/openda && \
    patch -Np1 -i /usr/src/patches/openda_model_hosts_environment.patch && \
    cd core/bin_external && \ 
    ./settings_local.sh && \
    ./settings_local_linux.sh && \
    cd ../.. && \
    ant build

# copy templates inside docker image
RUN mkdir -p /usr/src/templates
COPY templates /usr/src/templates

# copy scripts inside docker image
RUN mkdir -p /usr/src/scripts
COPY scripts /usr/src/scripts

# set environment variables
ENV PCRGLOBWB_MODEL_DIR=/usr/src/PCR-GLOBWB_model
ENV OPENDA_DIR=/usr/src/openda
ENV OPENDA_CONFIG_TEMPLATE_DIR=/usr/src/templates/openda
ENV PCRGLOBWB_CONFIG_TEMPLATE_DIR=/usr/src/templates/pcrglobwb
