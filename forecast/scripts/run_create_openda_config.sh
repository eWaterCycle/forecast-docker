#!/bin/bash

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

if [[ x${MODEL_HOSTS} == "x_default" ]]; then
  export MODEL_HOSTS=""
fi

python /usr/src/scripts/create_openda_config.py

tar cvzf openda_config.tar.gz openda_config
