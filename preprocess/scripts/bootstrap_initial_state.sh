#!/bin/bash

#Bootstrap initial state by copying file to reference workdir (even though that never ran)

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

#Refuses to overwrite files to make sure strange things do not happen

if [ -e $REFERENCE_INITIAL_STATE_FILE ]
then
    echo "Reference state file $REFERENCE_INITIAL_STATE_FILE already exists! No need to bootstrap"
    exit 1
fi

mkdir -p $REFERENCE_INITIAL_STATE_DIR

cp $BOOTSTRAP_INITIAL_STATE_FILE $REFERENCE_INITIAL_STATE_FILE

