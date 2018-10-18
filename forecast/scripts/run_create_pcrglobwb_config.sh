#!/bin/bash

# stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# define alternative date format
STARTTIME=$(date -d ${STARTTIME} +"%Y-%m-%d")
ENDTIME=$(date -d ${ENDTIME} +"%Y-%m-%d")

if [[ "$ZERO_STATE" == "yes" ]]
then
    export PCRGLOBWB_CONFIG_TEMPLATE_DIR=$PWD
    sed -E 's/(.*)=.*initial_conditions_dir.*/\1 = 0/' /usr/src/templates/pcrglobwb/$PCRGLOBWB_CONFIG_TEMPLATE > $PCRGLOBWB_CONFIG_TEMPLATE
fi

python /usr/src/scripts/create_pcrglobwb_config.py
