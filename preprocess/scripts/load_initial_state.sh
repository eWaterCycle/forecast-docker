#!/bin/bash

#Load initial state by unpacking state file (usually from previous cycle)

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

tar xvf $INITIAL_STATE_FILE

mkdir -p $IO_DIR/initial

cp -r * $IO_DIR/initial
