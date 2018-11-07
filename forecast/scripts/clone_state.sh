#!/bin/bash

# eWaterCycle forecast running script
# Copies all needed files into the workdir of this job, then calls openda

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

tar xvf ${INPUT_STATE}

mkdir -p output_state/state

printf -v srcPadded '%02d' ${ORG}
SRC="state/state-member${srcPadded}"

for ensembleMember in $(seq 0 $NCLONES)
do

  printf -v ensembleMemberPadded '%02d' ${ensembleMember}

  TARGET="output_state/state/state-member${ensembleMemberPadded}"

  mkdir -p ${TARGET}

  cp -r ${SRC}/* ${TARGET}/
done

tar cjf output_state.tar.bz2 -C output_state state
