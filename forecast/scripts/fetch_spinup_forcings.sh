#!/bin/bash

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit


#default
URL="https://researchdrive.surfsara.nl/index.php/s/0RbCE3LQ7MaoCQc/download"

if [[ x${FORCINGS_URL} != "x_default" ]]; then
  URL=${FORCINGS_URL}
fi

wget ${URL} -O forcings.tar.gz
