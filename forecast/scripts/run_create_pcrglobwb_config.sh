#!/bin/bash

# stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# define alternative date format
STARTTIME=$(date -d ${STARTTIME} +"%Y-%m-%d")
ENDTIME=$(date -d ${ENDTIME} +"%Y-%m-%d")

if [[ x"$SPINUP" != "xfalse" ]]
then
    export PCRGLOBWB_CONFIG_TEMPLATE_DIR=$PWD
    sed -E 's/(.*)=.*initial_conditions_dir.*/\1 = 0/' /usr/src/templates/pcrglobwb/$PCRGLOBWB_CONFIG_TEMPLATE > $PCRGLOBWB_CONFIG_TEMPLATE
    awk '/maxSpinUpsInYears/ {$3="'$MAX_SPINUP'"} {print $0}' $PCRGLOBWB_CONFIG_TEMPLATE > _tmp && mv _tmp $PCRGLOBWB_CONFIG_TEMPLATE
fi

python /usr/src/scripts/create_pcrglobwb_config.py
