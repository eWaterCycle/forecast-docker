#!/bin/bash

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

python /usr/src/scripts/create_openda_config.py

tar cvzf openda_config.tar.gz openda_config
