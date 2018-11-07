#!/bin/bash

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# todo: implement override for default and setting it according to input resolution


#default
URL="https://researchdrive.surfsara.nl/index.php/s/f8BoO18744iiWZv/download"

if [[ x${HYDROWORLD_URL} != "x_default" ]]; then
  URL=${HYDROWORLD_URL}
fi

wget ${URL} -O hydroworld.tar.gz
