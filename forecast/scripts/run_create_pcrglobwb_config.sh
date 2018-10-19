#!/bin/bash

# stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# define alternative date format
STARTTIME=$(date -d ${STARTTIME} +"%Y-%m-%d")
ENDTIME=$(date -d ${ENDTIME} +"%Y-%m-%d")

python /usr/src/scripts/create_pcrglobwb_config.py
